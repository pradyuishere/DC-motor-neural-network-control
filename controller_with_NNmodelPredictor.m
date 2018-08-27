function [ Y, voltage_out ] = controller_with_NNmodelPredictor( Yin, WC0, WC1, W0, W1)
    voltage_out = [];
    rpm_past = 0;
    Y = [];
    count1 = 0;
    for count = 1:size(Yin,1)
        count1 = count1+1;
        C1 = [1,Yin(count),rpm_past];
        c2 = tanh(C1*WC0);
        C2 = [1, c2];
        a1 = C2*WC1;
        voltage_out(end+1) = a1;
        A1 = [1,rpm_past, a1];
        a2 = tanh(A1*W0);
        A2 = [1,a2];
        a3  = A2*W1;
        Y(end+1) = a3;
        rpm_past = a3;
    end
end