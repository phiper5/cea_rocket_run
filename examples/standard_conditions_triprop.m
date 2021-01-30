addpath('..\');

inp = containers.Map;
inp('type') = 'eq fr';              % Sets the type of CEA calculation
inp('p') = 1000;                % Chamber pressure
inp('pip') = 1000 / 14.7;                % Chamber pressure
inp('p_unit') = 'psi';              % Chamber pressure units
inp('o/f') = 0.6:0.1:2;               % Mixture ratio
inp('fuel') = {'Li(L)', 'H2(L)'};             % Fuel name from thermo.inp
inp('fuel_t') = [454, 20];
inp('ox') = 'F2(L)';              % Ox name from thermo.inp
inp('ox_t') = 90;
inp('file_name') = 'temp';

Li_wt = 30:2:60;
leg = {};
figure;
hold on;
for i = 1:length(Li_wt)
    inp('fuel_wt%') = [Li_wt(i), 100-Li_wt(i)];
    data = cea_rocket_run(inp);     % Call the CEA MATLAB code

    data_eq = data('eq');
    data_fr = data('fr');

    isp = squeeze((data_eq('isp') + data_fr('isp')) / 2);
    T = squeeze(data_eq('t'));
    
    plot(inp('o/f'), isp(:, 2) / 9.807);
%     plot(inp('o/f'), T(:, 1));
    leg{i} = ['Be = ', num2str(Li_wt(i)), '%'];
end
legend(leg);