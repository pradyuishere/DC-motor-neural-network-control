function [ WC0, WC1 ] = controller_network( X0, Y, W0, W1 )
%This function is used to determine the weights to be assigned to the
%controller.
WC0 = [];
WC1 = [];
alpha = 1;
cost = [];
for neuron_countc = 20:20
    %Initialising the weights and forward propogating the net
    C1 = [ones(size(Y,1),1),Y,X0(:,1)];
    WC0 = rand(size(C1,2),neuron_countc);
    c2 = tanh(C1*WC0);
    C2 = [ones(size(c2,1),1), c2];
    WC1 = rand(size(C2,2),size(X0,2)-1);
    a1 = C2*WC1;
    A1 = [ones(size(a1,1),1),X0(:,1), a1];
    a2 = tanh(A1*W0);
    A2 = [ones(size(a2,1),1),a2];
    a3  = A2*W1;
    for inter = 1:2500
        c2 = tanh(C1*WC0);
        C2 = [ones(size(c2,1),1), c2];
        a1 = C2*WC1;
        A1 = [ones(size(a1,1),1), X0(:,1), a1];
        a2 = tanh(A1*W0);
        A2 = [ones(size(a2,1),1),a2];
        a3  = A2*W1;
        
        %backpropogating the errors
        lambda3 = a3-Y;
        std(lambda3)
        lambda12 = lambda3*W1'.*(1.-(A2.^2));
        lambda2 = lambda12(:,2:size(lambda12,2));
        lambdac13 = lambda2*W0';
        lambdac3 = lambdac13(:,3:size(lambdac13,2));
        lambdac12 = lambdac3*WC1'.*(1.-(C2.^2));
        lambdac2 = lambdac12(:,2:size(lambdac12,2));
        %calcuating the deltas
        deltac2 = C2'*lambdac3./size(X0,1);
        deltac1 = C1'*lambdac2./size(X0,1);
        %Resetting the weights
        WC0 = WC0 - alpha.*(deltac1);
        WC1 = WC1 - alpha.*(deltac2)./10;
    end
cost_this = sum((a3-Y).^2,1)/size(a3,1);
cost(end+1) = cost_this;
end
    

end

