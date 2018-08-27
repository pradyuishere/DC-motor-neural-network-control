% Initialization
clear ; close all; clc
%--------------------------------------------------------------------------
nets = [];
errors = [];

%State space model of dc motor
R = 1;                % Ohms
L = 0.5;                % Henrys
Km = 0.1;               % torque constant
Kb = 0.1;               % back emf constant
Kf = 0.2;               % Nms
J = 0.02;               % kg.m^2/s^2

h1 = tf(Km,[L R]);            % armature
h2 = tf(1,[J Kf]);            % eqn of motion
dcm = ss(h2) * [h1 , 1];      % w = h2 * (h1*Va + Td)
dcm = feedback(dcm,Kb,1,1);   % close back emf loop


%--------------------------------------------------------------------------
range = [0,1];
% voltage_in = [idinput(1000,'prbs',[0,0.1]);zeros(100,1)];
voltage_in = [idinput(1000,'prbs',[0,0.1],range);idinput(1000,'prbs',[0,0.1])];
torque = zeros(size(voltage_in));
rpm = lsim(dcm,[voltage_in';torque(1:size(voltage_in,1))'],0:0.2:(size(voltage_in,1)-1)*0.2);
% plot(rpm)
rpm_past = rpm(1:end-1);
rpm_present = rpm(2:end);

inputs = [rpm_past, voltage_in(1:end-1)]';
targets = rpm_present';

%--------------------------------------------------------------------------
hiddenLayerSize = 10;
net = fitnet(hiddenLayerSize);
    
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
    
[net,tr] = train(net,inputs,targets);
nn_output = net(inputs);
plot(targets)
hold
plot(nn_output)
hold off
%%
%--------------------------------------------------------------------------
step_input = load("D:\matlab\matlab_codes1\step.csv")';
step_output = lsim(dcm,[step_input;torque(1:size(step_input,2))'],...
    0:0.2:(size(step_input,2)-1)*0.2)';
%-------------------------------------------------------------------------- 
rpm_past = 0;
net_step_out = [];
for count2 = 1:size(step_input,2)
    rpm_past = net([rpm_past;step_input(count2)]);
    net_step_out(end+1) = rpm_past;
end
errors(end+1) = perform(net,step_output,net_step_out)

plot(net_step_out)
hold on
plot(step_output)
plot(step_input)