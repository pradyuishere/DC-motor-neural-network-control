function [ Y ] = controller_predict( X, X0, WC0, WC1, W0, W1)
%UNTITLED Summary of this function goes here
%   Here, X is the the input to the controller, where the controller
%   behaves as Y = f(X) but since for test cases only, f(X) = X = Y,
%   everywhere else Y is substitute instead of X.
rpm_past = 0;
Y = [];
count1 = 0;
for count = 1:size(X,1)
        count1 = count1+1;
        C1 = [1,X(count),rpm_past];
        c2 = tanh(C1*WC0);
        C2 = [1, c2];
        a1 = C2*WC1;
        A1 = [1,X(count), a1];
        a2 = tanh(A1*W0);
        A2 = [1,a2];
        a3  = A2*W1;
        Y(end+1) = a3;
        rpm_past = a3;
end
% for count = 1:size(torque_in,1)
%     Xin = [1, rpm_past,torque_in(count)];
%     a2 = tanh(Xin*W0);
%     A2 = [1, a2];
%     a3 = A2*W1;
%     Y(end+1) = a3;
%     rpm_past = a3;
% end
end

