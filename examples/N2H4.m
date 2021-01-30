addpath('..\');

inp = containers.Map;
inp('type') = 'eq fr';              % Sets the type of CEA calculation
inp('p') = 100 * 6894.76 / 1e5;                % Chamber pressure
inp('pip') = 100 / 14.7;                % Chamber pressure
inp('p_unit') = 'psi';               % Mixture ratio
inp('fuel') = 'N2H4(L)';             % Fuel name from thermo.inp
inp('file_name') = 'test.inp';

data = cea_rocket_run(inp);     % Call the CEA MATLAB code

data_eq = data('eq');
data_fr = data('fr');

ivac = squeeze(data_eq('ivac'));
t = squeeze(data_eq('t'));