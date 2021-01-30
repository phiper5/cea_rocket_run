addpath('..\');
CEA_RUN = true;
CEA_SAVE_FILE = 'Temp';

inp = containers.Map;
inp('file_name') = 'Temp.inp';    % Input/output file name
inp('type') = 'eq';              % Sets the type of CEA calculation
inp('p') = 100*6894.76/1E5;             % Chamber pressure
inp('p_unit') = 'bar';           % Chamber pressure units
% inp('o/f') = 14.2;               % Phi input broken, o/f equates to phi of 1
inp('phi') = 1;
inp('fuel') = 'JP-10(L)';        % Fuel name from thermo.inp
inp('fuel_t')=298.15;
inp('fuel_t_unit')='K';
inp('ox') = 'Air';              % Ox name from thermo.inpj
inp('ox_t')=600;
inp('ox_t_unit')='K';
inp('pip')=3;
if CEA_RUN == 1
    data = cea_rocket_run(inp);     % Call the CEA MATLAB code
    save(CEA_SAVE_FILE,'data');
else
    load(CEA_SAVE_FILE);
end
