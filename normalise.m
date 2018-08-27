function [ Y ] = normalise( X )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
Y = X-mean(X,1);
Y = Y/100000000;

end

