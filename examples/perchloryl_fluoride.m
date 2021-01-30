addpath('..\');

inp = containers.Map;
inp('type') = 'eq fr';              % Sets the type of CEA calculation
inp('p') = 200 * 6894.76 / 1e5;                % Chamber pressure
inp('pip') = 200 / 0.1;                % Chamber pressure
inp('p_unit') = 'psi';              % Chamber pressure units
inp('o/f') = 1:0.25:4;               % Mixture ratio
inp('fuel') = 'CH6N2(L)';             % Fuel name from thermo.inp
inp('ox') = 'CLO3F(L)';              % Ox name from thermo.inp
inp('ox') = 'N2O4(L)';              % Ox name from thermo.inp
data = cea_rocket_run(inp);     % Call the CEA MATLAB code

data_eq = data('eq');
data_fr = data('fr');

ivac = squeeze(data_eq('ivac'));

figure;
plot(inp('o/f'), ivac(:, 2) / 9.807);