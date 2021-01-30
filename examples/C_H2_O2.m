% See how carbon and H2 flame temps change with pressure and O/F
addpath('..\');

%% Carbon CEA
inp = containers.Map;
inp('type') = 'eq fr';              % Sets the type of CEA calculation
inp('p') = linspace(100, 1000, 10);  % Chamber pressure
inp('p_unit') = 'psi';              % Chamber pressure units
inp('o/f') = 1:0.25:4;               % Mixture ratio
inp('fuel') = 'C(gr)';             % Fuel name from thermo.inp
inp('ox') = 'O2';              % Ox name from thermo.inp
data = cea_rocket_run(inp);     % Call the CEA MATLAB code
data_eq = data('eq');
T = squeeze(data_eq('t'));

%% Carbon plot
figure;
hold on;
for i = 1:size(T, 1)
    plot(inp('o/f'), T(i, :), 'k');
end

%% H2 CEA
inp('fuel') = 'H2';             % Fuel name from thermo.inp
inp('o/f') = 5.5:0.25:8.5;               % Mixture ratio
data = cea_rocket_run(inp);     % Call the CEA MATLAB code
data_eq = data('eq');
T = squeeze(data_eq('t'));

%% H2 plot
for i = 1:size(T, 1)
    plot(inp('o/f'), T(i, :), 'k--');
end

%% RP CEA
inp('fuel') = 'RP-1';             % Fuel name from thermo.inp
inp('o/f') = 2:0.25:4;               % Mixture ratio
data = cea_rocket_run(inp);     % Call the CEA MATLAB code
data_eq = data('eq');
T = squeeze(data_eq('t'));

%% RP plot
for i = 1:size(T, 1)
    plot(inp('o/f'), T(i, :), 'k-.');
end