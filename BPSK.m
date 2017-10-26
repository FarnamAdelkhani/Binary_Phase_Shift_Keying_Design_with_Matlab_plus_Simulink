% Open the Model
clear all; clc; close all;
%Set The correct variable names and model names here
% *************************************************
mdl = 'BPSK_Model';
% *************************************************
%% Open up the simulation and initialize output vars
open_system(mdl); %% Open the Simulink Model if it is not open. It has to be in the same folder
N0_vals = 1:20; % For the second simulation part
G_vals = 1:10;  % For the first part of simulation
n = length(G_vals); % valid only for part 1 of simulation
E0N0 = zeros(1,n);
Pb_theory = zeros(1,n);
Pb_prac = zeros(1,n);
%% Part 1: Loop and simulate for n different Gain values with N0 = 10
for i = 1:n
    N_0 = Simulink.Parameter(10); % In the model, the constant block 'Noise' needs to be set to this variable
    G = Simulink.Parameter(G_vals(i)); % In the model the value of the block Gain needs to be set to this variable
    % Set parameters for the simulation
    paramNameValStruct.SimulationMode = 'norm';
    paramNameValStruct.AbsTol         = '1e-5';
    paramNameValStruct.SaveState      = 'on';
    paramNameValStruct.StateSaveName  = 'xoutNew';
    paramNameValStruct.SaveOutput     = 'on';
    paramNameValStruct.OutputSaveName = 'yout';
    paramNameValStruct.StopTime = '50';
    paramNameValStruct.ZeroCross = 'on';
    paramNameValStruct.Solver = 'ode45';
    % Run the simulation and store the simulation output results to simout
    simout = sim(mdl,paramNameValStruct);
    E0 = G.Value^2/2; % Theoretical value of E_0
    N0 = N_0.Value; % The value of N_0 in this case is 10
    E0N0(i) = E0/N0; % Store the theoretical value of E_0/N_0 to the corresponding array
    Pb_theory(i) = qfunc(sqrt(2*E0/N0)); % Calculate and store the theoretical value of Pb
    Pb_prac(i) = simout.get('Pb').signals.values(end,1); % Get the final value of Pb from the current simulation run from the output struct
end
%% Plot the data obtained
figure(1)
plot(E0N0,Pb_theory,'b',E0N0,Pb_prac,'r');
legend('Theoretica value of Pb','Practical value of Pb');
xlabel('{{E_0 / N_0}}');
ylabel('P_b');
title('P_b against E_0 / N_0 for N_0 = 10 and 10 different values of Gain');
grid;
%% Part 2: Loop and simulate through 20 different N0 values for Gain = 5
n = length(N0_vals);
E0N0 = zeros(1,n);
Pb_theory = zeros(1,n);
Pb_prac = zeros(1,n);
for i = 1:n
    N_0 = Simulink.Parameter(N0_vals(i));
    G = Simulink.Parameter(5);
    paramNameValStruct.SimulationMode = 'norm';
    paramNameValStruct.AbsTol         = '1e-5';
    paramNameValStruct.SaveState      = 'on';
    paramNameValStruct.StateSaveName  = 'xoutNew';
    paramNameValStruct.SaveOutput     = 'on';
    paramNameValStruct.OutputSaveName = 'yout';
    paramNameValStruct.StopTime = '50';
    paramNameValStruct.ZeroCross = 'on';
    paramNameValStruct.Solver = 'ode45';
    simout = sim(mdl,paramNameValStruct);
    E0 = G.Value^2/2;
    N0 = N_0.Value;
    E0N0(i) = E0/N0;
    Pb_theory(i) = qfunc(sqrt(2*E0/N0));
    Pb_prac(i) = simout.get('Pb').signals.values(end,1);
end
%% Plot the data obtained
figure(2)
plot(E0N0,Pb_theory,'b',E0N0,Pb_prac,'r');
legend('Theoretica value of Pb','Practical value of Pb');
xlabel('{{E_0 / N_0}}');
ylabel('P_b');
title('P_b against E_0 / N_0 for Gain = 5 and 10 different values of N_0');
grid;