function [ W0, W1, cost ] = oneLayerNetwork( alpha, X0, Y)
%This is a single layered neural network
cost = [];
W1 = [];
W0 = [];
for neuron_count = 20:20
    %Initialising the weights and forward propogating the net
    A1 = [ones(size(X0,1),1),X0];
    W0 = rand(size(A1,2),neuron_count);
    a2 = sigmoid(A1*W0);
    A2 = [ones(size(a2,1),1),a2];
    W1 = rand(size(A2,2),1);
    for inter = 1:10000
        a2 = tanh(A1*W0);
        A2 = [ones(size(a2,1),1),a2];
        a3  = A2*W1;
        %backpropogating the errors
        lambda3 = a3-Y;
        lambda12 = lambda3*W1'.*(1.-(A2.^2));
        lambda2 = lambda12(:,2:size(lambda12,2));
        delta2 = A2'*lambda3./size(X0,1);
        delta1 = A1'*lambda2./size(X0,1);
        W0 = W0 - alpha.*(delta1);
        W1 = W1 - alpha.*delta2;
        cost_this = sum((a3-Y).^2,1)/size(a3,1)
    end
    cost_this = sum((a3-Y).^2,1)/size(a3,1);
end

