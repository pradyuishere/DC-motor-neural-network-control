function [ a4 ] = star( X0, W0, W1, W2, neuron_count )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
 A1 = [ones(size(X0,1),1),X0];
    W0 = rand(size(A1,2),neuron_count);
    a2 = sigmoid(A1*W0);
    sizea21 = size(a2);
    A2 = [ones(size(a2,1),1),a2];
    a3  = sigmoid(A2*W1);
    A3 = [ones(size(a3,1),1),a3];
    a4 = sigmoid(A3*W2);
    
end

