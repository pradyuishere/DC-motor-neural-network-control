function [ Y_out, voltage_out ] = controller_with_plant_model_predict( Yin...
    , torque, WC0, WC1, voltage_mean, voltage_std)
    voltage_out = [0];
    rpm_past = 0;
    Y_out = [];
    count1 = 0;
    %--------------------------------------------------------------------------
    %State space model of dc motor
    R = 1;                % Ohms
    L = 0.5;                % Henrys
    Km = 0.1;               % torque constant
    Kb = 0.1;               % back emf constant
    Kf = 0.2;               % Nms
    J = 0.02;               % kg.m^2/s^2

    h1 = tf(Km,[L R]);            % armature
    h2 = tf(1,[J Kf]);            % eqn of motion
    dcm = ss(h2) * [h1 , 1];      % w = h2 * (h1*Va + Td)
    dcm = feedback(dcm,Kb,1,1);   % close back emf loop
    Kff = 1/dcgain(dcm(1));
    dcm = dcm * diag([Kff,1]); 
    %--------------------------------------------------------------------------
    for count = 1:size(Yin,1)
        count1 = count1+1
        C1 = [1,Yin(count),rpm_past];
        c2 = tanh(C1*WC0);
        C2 = [1, c2];
        a1 = C2*WC1;
        voltage_out(end+1) = a1;
        current_output_from_plant = lsim(dcm,[voltage_out(1:count+1)*voltage_std+voltage_mean;...
                torque(1:count+1)'], 0:0.2:(count)*0.2);
%         if size(voltage_out,1)<20
%             current_output_from_plant = lsim(dcm,[voltage_out(1:count+1)*voltage_std+voltage_mean;...
%                 torque(1:count+1)'], 0:0.2:(count)*0.2);
%         else
%             current_output_from_plant = lsim(dcm,[voltage_out(count-19:count)*voltage_std+voltage_mean;...
%                 torque(count-19:count)'], 0:0.2:(20-1)*0.2);
%         end
        Y_out(end+1) = current_output_from_plant(end);
        rpm_past = Y_out(end);
    end
end