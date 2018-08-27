function [ Y ] = predict( torque_in, W0, W1)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
Y = [];
rpm_past =0;
for count = 1:size(torque_in,1)
    Xin = [1, rpm_past, torque_in(count)];
    a2 = tanh(Xin*W0);
    A2 = [1, a2];
    a3 = A2*W1;
    Y(end+1) = a3;
    rpm_past = a3;
end
end

