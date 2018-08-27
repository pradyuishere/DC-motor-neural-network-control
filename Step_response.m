% Initialization
clear ; close all; clc
%--------------------------------------------------------------------------
%Fixed parameters
alpha = 0.01; %Learning rate
cost = [];
cost1 = [];
x =1;
%--------------------------------------------------------------------------
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
voltage_in = load("D:\matlab\matlab_codes1\voltages_generated.csv");
voltage_in = [voltage_in(1:4000)'/std(voltage_in); idinput(500,'prbs',[0,0.1])];
torque = zeros(size(voltage_in));
rpm = lsim(dcm,[voltage_in';torque(1:size(voltage_in,1))'],0:0.2:(size(voltage_in,1)-1)*0.2);

% %--------------------------------------------------------------------------
% %Generating rpm
% rpm = lsim(dcm,[(voltage(2:end))';torque(2:end)'],0:0.2:0.2*size(voltage,1)-0.4);
% 
% rpm_train_present = rpm(2:floor(size(rpm)*0.6)-1);
% rpm_train_past = rpm(1:floor(size(rpm)*0.6-2));
% rpm_train_past1 = rpm(1:floor(size(rpm)*0.6)-2);
% rpm_val = rpm(floor(size(rpm)*0.6)+1:floor(size(rpm)*0.8));
% rpm_test = rpm(floor(size(rpm)*0.8)+1:floor(size(rpm)));
rpm_past = rpm(1:end-1);
rpm_present = rpm(2:end);
% % plot(rpm)
% % hold
% % plot(voltage)
% %--------------------------------------------------------------------------
% 
% %Input variables
% X0 = ([(rpm_train_past - mean(rpm_train_past))/std(rpm_train_past),(voltage_train_present-mean(voltage_train_present))/std(voltage_train_present)]);
% Y = ((rpm_train_present - mean(rpm_train_present))/std(rpm_train_present));
X0 = [ rpm_past, voltage_in(1:end-1)];
Y = rpm_present;
% %--------------------------------------------------------------------------
% %Training the neural networks
[W0, W1, cost] = oneLayerNetwork( alpha, X0, Y);
% %--------------------------------------------------------------------------
voltage_in = [voltage_in(1:4000)'];
% %Getting the test set predictions
 a3 = predict(voltage_in, W0, W1);
 plot(a3)
 hold on
 plot(rpm_present)
 hold off