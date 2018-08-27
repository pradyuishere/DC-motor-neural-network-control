inputs = csvread("D:\matlab\matlab_codes1\input.csv")';
targets = csvread("D:\matlab\matlab_codes1\output.csv")';
size(inputs)
size(targets)
% Create a Fitting Network
hiddenLayerSize = 10;
net = fitnet(hiddenLayerSize);

% Set up Division of Data for Training, Validation, Testing
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
 
% Train the Network
[net,tr] = train(net,inputs,targets);
 
% Test the Network
outputs = net(inputs);
errors = gsubtract(outputs,targets);
performance = perform(net,targets,outputs);

step_output = [];
step =load("D:\matlab\matlab_codes1\step.csv");
load("D:\matlab\matlab_codes1\step_out.csv");
rpm_past = 0;
for count=1:size(step,1)
    rpm_past = net([rpm_past;step(count)]);
    step_output(end+1) = rpm_past;
end

plot(step_out)
hold
plot(step_output)