function [ Y ] = step( X )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes h
Y = zeros(size(X,1),1);
Y1 = 1:size(X,1);
for i = Y1
    if X(i)>0
        Y(i)=1;
    end
end