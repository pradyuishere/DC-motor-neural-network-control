% Initialization
clear ; close all; clc
%--------------------------------------------------------------------------
%Importing the training data
load("D:\matlab\rpm.csv");
load("D:\matlab\torque.csv");
load("D:\matlab\voltage.csv");
% rpm = awgn(rpm,10);
% torque = awgn(torque,10);
% voltage = awgn(voltage,10);
rpm_train_present = rpm(3:floor(size(rpm)*0.6));
rpm_train_past = rpm(2:floor(size(rpm)*0.6)-1);
rpm_train_past1 = rpm(1:floor(size(rpm)*0.6)-2);
rpm_val = rpm(floor(size(rpm)*0.6)+1:floor(size(rpm)*0.8));
rpm_test = rpm(floor(size(rpm)*0.8)+1:floor(size(rpm)));
voltage_train_past = voltage(1:floor(size(voltage)*0.6-2));
voltage_train_present =voltage(2:floor(size(voltage)*0.6)-1);
voltage_val = voltage(floor(size(voltage)*0.6)+1:floor(size(voltage)*0.8));
voltage_test = voltage(floor(size(voltage)*0.8)+1:floor(size(voltage)));
torque_train_past = torque(1:floor(size(torque)*0.6-2));
torque_train_present =torque(2:floor(size(torque)*0.6)-1);
torque_val = torque(floor(size(torque)*0.6)+1:floor(size(torque)*0.8));
torque_test = torque(floor(size(torque)*0.8)+1:floor(size(torque)));
%--------------------------------------------------------------------------
%Fixed parameters
input_layer_size = 1;
output_layer_size = 1;
hidden_layer_count = 2;
alpha = 0.2;
cost = [];
W2 = [];
W1 = [];
W0 = [];
x =1;
count = 0;
average_input = mean(rpm_train_present,1);
%--------------------------------------------------------------------------
%Input variables
X0 = ([(voltage_train_present-mean(voltage_train_present))/std(voltage_train_present),(rpm_train_past - average_input)/std(rpm_train_present),(torque_train_present-mean(torque_train_present))/std(torque_train_present)]);
Y = ((rpm_train_present - mean(rpm_train_present))/std(rpm_train_present));
%--------------------------------------------------------------------------
%Calculate the best number of neurons in the hidden layers to prevent
%over or under fitting
for neuron_count = 20:20
    %Initialising the weights and forward propogating the net
    A1 = [ones(size(torque_train_past,1),1),X0];
    W0 = rand(size(A1,2),neuron_count);
    a2 = sigmoid(A1*W0);
    A2 = [ones(size(a2,1),1),a2];
    W1 = rand(size(A2,2),1);
    count = count+1;
    for inter = 1:40000
        a2 = tanh(A1*W0);
        A2 = [ones(size(a2,1),1),a2];
        a3  = A2*W1;
        %backpropogating the errors
        lambda3 = a3-Y;
        lambda12 = lambda3*W1'.*(1.-(A2.^2));
        lambda2 = lambda12(:,2:size(lambda12,2));
        delta2 = A2'*lambda3./size(rpm_train_present,1);
        delta1 = A1'*lambda2./size(rpm_train_present,1);
        W0 = W0 - alpha.*(delta1);
        W1 = W1 - alpha.*delta2
    end
    cost_this = sum((a3-Y).^2,1)/size(a3,1);
    cost(end+1) = cost_this;
end
