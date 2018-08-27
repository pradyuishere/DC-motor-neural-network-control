% Initialization
clear ; close all; clc
% %--------------------------------------------------------------------------
% %Importing the training data
% load("D:\matlab\matlab_codes1\rpm.csv");
% load("D:\matlab\matlab_codes1\torque.csv");
% load("D:\matlab\matlab_codes1\voltage.csv");
% rpm_train_present = rpm(3:floor(size(rpm)*0.6));
% rpm_train_past = rpm(2:floor(size(rpm)*0.6)-1);
% rpm_train_past1 = rpm(1:floor(size(rpm)*0.6)-2);
% rpm_val = rpm(floor(size(rpm)*0.6)+1:floor(size(rpm)*0.8));
% rpm_test = rpm(floor(size(rpm)*0.8)+1:floor(size(rpm)));
% voltage_train_past = voltage(1:floor(size(voltage)*0.6-2));
% voltage_train_present =voltage(2:floor(size(voltage)*0.6-1));
% voltage_val = voltage(floor(size(voltage)*0.6)+1:floor(size(voltage)*0.8));
% voltage_test = voltage(floor(size(voltage)*0.8)+1:floor(size(voltage)));
% torque_train_past = torque(1:floor(size(torque)*0.6-2));
% torque_train_present =torque(3:floor(size(torque)*0.6));
% torque_val = torque(floor(size(torque)*0.6)+1:floor(size(torque)*0.8));
% torque_test = torque(floor(size(torque)*0.8)+1:floor(size(torque)));
%--------------------------------------------------------------------------
%Fixed parameters
voltage = load("D:\matlab\matlab_codes1\voltages_generated.csv")';
voltage = voltage(1:2000)/std(voltage);
torque = zeros(size(voltage));
input_layer_size = 1;
output_layer_size = 1;
hidden_layer_count = 1;
alpha = 0.01;
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
Kff = 1/dcgain(dcm(1));
dcm = dcm * diag([Kff,1]); 
%--------------------------------------------------------------------------
%Generating rpm
rpm = lsim(dcm,[(voltage(2:end))';torque(2:end)'],0:0.2:0.2*size(voltage,1)-0.4);
rpm_past = rpm(1:end-1);
rpm_present = rpm(2:end);
% size(rpm)
% size(voltage)
% csvwrite("D:\matlab\matlab_codes1\input.csv",[rpm(1:end-1),voltage(2:end-1)]);
% csvwrite("D:\matlab\matlab_codes1\output.csv",rpm(2:end));
% rpm_train_present = rpm(2:floor(size(rpm)*0.6)-1);
% rpm_train_past = rpm(1:floor(size(rpm)*0.6-2));
% rpm_train_past1 = rpm(1:floor(size(rpm)*0.6)-2);
% rpm_val = rpm(floor(size(rpm)*0.6)+1:floor(size(rpm)*0.8));
% rpm_test = rpm(floor(size(rpm)*0.8)+1:floor(size(rpm)));
% voltage_mean = mean(voltage);
% voltage_std = std(voltage);
% plot(rpm)
% hold
% plot(voltage)
%--------------------------------------------------------------------------

%Input variables
% X0 = ([(rpm_train_past - mean(rpm_train_past))/std(rpm_train_past),(voltage_train_present-mean(voltage_train_present))/std(voltage_train_present)]);
% Y = ((rpm_train_present - mean(rpm_train_present))/std(rpm_train_present));
X0 = [rpm_past, voltage(2:end-1)];
Y = rpm_present;
%--------------------------------------------------------------------------
%Training the neural networks
[W0, W1, cost] = oneLayerNetwork( alpha, X0, Y);
[ WC0, WC1 ] = controller_network( X0, Y, W0, W1 );
%--------------------------------------------------------------------------
%Getting the test set predictions
voltage_mean = 0;
voltage_std = 1;
rpm_in = rpm;
% voltage_mean = mean(voltage);
% voltage_std = std(voltage);
[ Y_out, voltage_out ] = controller_with_plant_model_predict( rpm_in, torque, WC0, WC1, voltage_mean, voltage_std);

plot(Y_out)
hold on
plot(rpm(2:end))
hold off