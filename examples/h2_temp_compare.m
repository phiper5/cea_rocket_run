addpath('..\');

inp = containers.Map;
inp('type') = 'eq fr';              % Sets the type of CEA calculation
inp('p') = 100 * 6894.76 / 1e5;                % Chamber pressure
inp('pip') = 100 / 14.7;                % Chamber pressure
inp('p_unit') = 'psi';              % Chamber pressure units
inp('o/f') = 0.5:0.25:1.5;               % Mixture ratio
inp('fuel') = 'H2';             % Fuel name from thermo.inp
inp('ox') = 'O2';              % Ox name from thermo.inp
data = cea_rocket_run(inp);     % Call the CEA MATLAB code

data_eq = data('eq');
data_fr = data('fr');

temperature = squeeze(data_eq('t'));

figure;
plot(inp('o/f'), temperature(:, 1));