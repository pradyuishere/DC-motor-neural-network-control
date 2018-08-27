function [ a3 ] = star2( A1, W0, W1 )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
 
    
    a2 = tanh(A1*W0);
    A2 = [ones(size(a2,1),1),a2];
    a3  = (A2*W1);
    
end


