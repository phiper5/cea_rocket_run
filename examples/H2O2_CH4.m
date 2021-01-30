addpath('..\');

inp = containers.Map;
inp('type') = 'eq fr';              % Sets the type of CEA calculation
inp('p') = 1000 * 6894.76 / 1e5;                % Chamber pressure
inp('pip') = 1000 / 14.7;                % Chamber pressure
inp('p_unit') = 'psi';              % Chamber pressure units
inp('o/f') = 3:0.25:7;               % Mixture ratio
inp('fuel') = 'RP-1';             % Fuel name from thermo.inp
inp('ox') = 'H2O2(L)';              % Ox name from thermo.inp
inp('file_name') = 'benzene.inp';    % Input/output file name

data = cea_rocket_run(inp);     % Call the CEA MATLAB code

data_eq = data('eq');
data_fr = data('fr');

ivac = squeeze(data_eq('ivac'));
t = squeeze(data_eq('t'));

figure;
plot(inp('o/f'), ivac(:, 2) / 9.807);
hold on;
yyaxis right;
plot(inp('o/f'), t(:, 1));