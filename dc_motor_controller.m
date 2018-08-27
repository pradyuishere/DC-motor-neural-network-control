% Initialization
clear ; close all; clc
%--------------------------------------------------------------------------
%Importing the training data
load("D:\matlab\rpm.csv");
load("D:\matlab\torque.csv");
load("D:\matlab\voltage.csv");
rpm = (rpm - mean(rpm))/std(rpm);
rpm_present = rpm(2:size(rpm,1),:);
rpm_past = rpm(1:size(rpm,1)-1,:);
torque = (torque - mean(torque))/std(torque);
torque_present = torque(2:size(torque,1),:);
torque_past = torque(1:size(torque,1)-1,:);
voltage = (voltage - mean(voltage))/std(voltage);
voltage_present = voltage(2:size(voltage,1),:);
voltage_past = voltage(1:size(voltage,1),:);
%--------------------------------------------------------------------------
%Setting the initial weights
alpha = 0.2;
X0 = [rpm_past(1:500,:), voltage_present(1:500,:)];
Y = rpm_present(1:500,:);
W0 = [];
W1 = [];
cost = 0;

example = 500;
stop = 1;
count = 501;
mean_Y = 0;
mean_voltage = 0;
mean_rpm_past = 0;
stdev_Y = 0;
stdev_voltage = 0;
stdev_rpm_past = 0;
nstd = 5;
errors = [];
predictions = [];
rpm_current = [];
%--------------------------------------------------------------------------
for neuron_count2 = 20:20
    while example < size(torque_past,1)
        example = example+1;
        if stop == 1
            %--------------------------------------------------------------
            mean_Y = mean(rpm_present(example-500:example));
            mean_rpm_past = mean(rpm_past(example-500:example));
            mean_voltage = mean(voltage_present(example-500:example));
            stdev_Y = std(rpm_present(example-500:example));
            stdev_rpm_past = std(rpm_past(example-500:example));
            stdev_voltage = std(voltage_present(example-500:example));
            %--------------------------------------------------------------
            Y = (rpm_present(example-500:example) - mean_Y)/stdev_Y;
            X0 = [(rpm_past(example-500:example)-mean_rpm_past)/stdev_rpm_past...
                ,(voltage_present(example-500:example,:)-mean_voltage)/stdev_voltage];
            %--------------------------------------------------------------
            [W0, W1, cost] = oneLayerNetwork( alpha, X0, Y);
            [ WC0, WC1 ] = controller_network( X0, Y, W0, W1 );
            %--------------------------------------------------------------
            mean_errors = mean(controller_predict( Y, X0, WC0, WC1, W0, W1)-...
                (rpm_present(example)-mean_Y)/stdev_Y);
            stdev_errors =std( controller_predict( Y, X0, WC0, WC1, W0, W1)-...
                (rpm_present(example)-mean_Y)/stdev_Y);
            rpm_value = controller_predict( (rpm_present(example)-mean_Y)/stdev_Y...
                , X0(end), WC0, WC1, W0, W1);
            %--------------------------------------------------------------
            stop = 0;
            errors = [];
        else
            count = count+1;
            X = [1, (rpm_value-mean_rpm_past)/stdev_rpm_past...
                ,(voltage_present(example)-mean_voltage)/stdev_voltage];
            errors(end+1) = controller_predict( (rpm_present(example)-mean_Y)/stdev_Y,...
                X,WC0, WC1, W0, W1)-(rpm_present(example)-mean_Y)/stdev_Y;
            predictions(end+1) = controller_predict( (rpm_present(example)-mean_Y)/stdev_Y...
                , X, WC0, WC1, W0, W1);
            rpm_current(end+1) = (rpm_present(example)-mean_Y)/stdev_Y;
            rpm_value = controller_predict( (rpm_present(example)-mean_Y)/stdev_Y...
                , X, WC0, WC1, W0, W1);
            if count > 500
                if cummulative_error_flag( errors, mean_errors, stdev_errors, nstd ) == 1
                    count = 0;
                end
            end
            if count == 500
                stop = 1;
            end
        end
    end
    plot(predictions)
    hold
    plot(rpm_current)
end