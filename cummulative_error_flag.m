function [ Y ] = cummulative_error_flag( X, mean, stdev, n )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
if (size(X)-30) > 0
    if(mean(X(size(X)-30:size(X),:)-mean)>n*stdev)
        Y = 1;
    else
        Y = 0;
    end
else
    Y = 0;
end
end

