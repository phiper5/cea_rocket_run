addpath('..\');

inp = containers.Map;
inp('type') = 'eq fr';              % Sets the type of CEA calculation
inp('p') = 200 * 6894.76 / 1e5;                % Chamber pressure
inp('pip') = 200 / 14.7;                % Chamber pressure
inp('p_unit') = 'psi';              % Chamber pressure units
inp('o/f') = 1:0.25:4;               % Mixture ratio
inp('fuel') = 'Be';             % Fuel name from thermo.inp
inp('ox') = 'O2';              % Ox name from thermo.inp
inp('file_name') = 'Be.inp';    % Input/output file name

data = cea_rocket_run(inp);     % Call the CEA MATLAB code

data_eq = data('eq');
data_fr = data('fr');

ivac = squeeze(data_eq('ivac'));

figure;
plot(inp('o/f'), ivac(:, 2) / 9.807);