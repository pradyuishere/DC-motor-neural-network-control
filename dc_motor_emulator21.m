% Initialization
clear ; close all; clc
%--------------------------------------------------------------------------
%Importing the training data
load("D:\matlab\rpm.csv");
load("D:\matlab\torque.csv");
rpm_train_present = rpm(3:floor(size(rpm)*0.6));
rpm_train_past = rpm(2:floor(size(rpm)*0.6)-1);
rpm_train_past1 = rpm(1:floor(size(rpm)*0.6)-2);
rpm_val = rpm(floor(size(rpm)*0.6)+1:floor(size(rpm)*0.8));
rpm_val_past = rpm(floor(size(rpm)*0.6):floor(size(rpm)*0.8)-1);
rpm_test = rpm(floor(size(rpm)*0.8)+1:floor(size(rpm)));
torque_train_past = torque(1:floor(size(torque)*0.6-2));
torque_train_present =torque(3:floor(size(torque)*0.6));
torque_val = torque(floor(size(torque)*0.6)+1:floor(size(torque)*0.8));
torque_test = torque(floor(size(torque)*0.8)+1:floor(size(torque)));
%--------------------------------------------------------------------------
%Fixed parameters
input_layer_size = 1;
output_layer_size = 1;
hidden_layer_count = 2;
alpha = 1;
cost = [];
W2 = [];
W1 = [];
W0 = [];
x =1;
count = 0;
average_input = mean(rpm_train_present,1);
%--------------------------------------------------------------------------
%Input variables
X0 = [(rpm_train_past - average_input)/std(rpm_train_present),(torque_train_present-mean(torque_train_present))/std(torque_train_present)];
Y = ((rpm_train_present - mean(rpm_train_present))/std(rpm_train_present));
%--------------------------------------------------------------------------
%Calculate the best number of neurons in the hidden layers to prevent
%over or under fitting
for neuron_count = 10:10
    %Initialising the weights and forward propogating the net
    A1 = [ones(size(torque_train_past,1),1),X0];
    W0 = rand(size(A1,2),neuron_count);
    a2 = sigmoid(A1*W0);
    sizea21 = size(a2);
    for neuron_count1 = 10:10
       A2 = [ones(size(a2,1),1),a2];
       W1 = rand(size(A2,2),neuron_count1);
       a3 = sigmoid(A2*W1);
       sizea31 = size(a3);
       A3 = [ones(size(a3,1),1),a3];
       W2 = rand(size(A3,2),1);
       a4 = sigmoid(A3*W2);
       count = count+1;
       for inter = 1:10000
            a2 = sigmoid(A1*W0);
            A2 = [ones(size(a2,1),1),a2];
            size(a2);
            a3 = sigmoid(A2*W1);
            A3 = [ones(size(a3,1),1),a3];
            a4 = sigmoid(A3*W2);
            %backpropogating the errors
            lambda4 = a4-Y;
            size(lambda4*W2');
            lambda13 = lambda4*W2'.*A3.*(1-A3);
            size(lambda13);
            lambda3 = lambda13(:,2:size(lambda13,2));
            lambda12 = lambda3*W1'.*A2.*(1-A2);
            size(lambda12);
            lambda2 = lambda12(:,2:size(lambda12,2));
            %Finding the gradient
            delta3 = A3'*lambda4/size(rpm_train_present,1);
            delta2 = A2'*lambda3/size(rpm_train_present,1);
            delta1 = A1'*lambda2/size(rpm_train_present,1); 
            W0 = W0 - alpha*(delta1);
            W1 = W1 - alpha*delta2;
            W2 = W2 - alpha*delta3;
       end
       
    end
    cost_iter = sum(-Y.*log(a4)-(1-Y).*log(1-a4))/size(rpm_train_present,1)/size(rpm_train_present,1);
    cost(end+1) = cost_iter;
end
plot(cost)