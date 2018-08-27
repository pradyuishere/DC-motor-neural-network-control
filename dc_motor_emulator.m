% Initialization
clear ; close all; clc
%--------------------------------------------------------------------------
%Importing the training data
load("D:\matlab\matlab_codes1\rpm.csv");
load("D:\matlab\matlab_codes1\torque.csv");
load("D:\matlab\matlab_codes1\voltage.csv");
rpm_train_present = rpm(3:floor(size(rpm)*0.6));
rpm_train_past = rpm(2:floor(size(rpm)*0.6)-1);
rpm_train_past1 = rpm(1:floor(size(rpm)*0.6)-2);
rpm_val = rpm(floor(size(rpm)*0.6)+1:floor(size(rpm)*0.8));
rpm_test = rpm(floor(size(rpm)*0.8)+1:floor(size(rpm)));
voltage_train_past = voltage(1:floor(size(voltage)*0.6-2));
voltage_train_present =voltage(2:floor(size(voltage)*0.6-1));
voltage_val = voltage(floor(size(voltage)*0.6)+1:floor(size(voltage)*0.8));
voltage_test = voltage(floor(size(voltage)*0.8)+1:floor(size(voltage)));
torque_train_past = torque(1:floor(size(torque)*0.6-2));
torque_train_present =torque(3:floor(size(torque)*0.6));
torque_val = torque(floor(size(torque)*0.6)+1:floor(size(torque)*0.8));
torque_test = torque(floor(size(torque)*0.8)+1:floor(size(torque)));
%--------------------------------------------------------------------------
%Fixed parameters
input_layer_size = 1;
output_layer_size = 1;
hidden_layer_count = 1;
alpha = 0.2;
cost = [];
cost1 = [];
x =1;
average_input = mean(rpm_train_present,1);
%--------------------------------------------------------------------------
%Input variables
X0 = ([(rpm_train_past - average_input)/std(rpm_train_past),(voltage_train_present-mean(voltage_train_present))/std(voltage_train_present)]);
Y = ((rpm_train_present - mean(rpm_train_present))/std(rpm_train_present));
%--------------------------------------------------------------------------
%Calculate the best number of neurons in the hidden layers to prevent
%over or under fitting
[W0, W1, cost] = oneLayerNetwork( alpha, X0, Y);
a3 = predict((voltage-mean(voltage))/std(voltage), W0, W1);

Y_normal = a3*std(rpm_train_present)+mean(rpm_train_present);

