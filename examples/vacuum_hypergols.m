addpath('..\');

dOF = 0.1;
CEA_settings = { ...
    {'H2(L)', 'O2(L)', 20, 90, 3.3:dOF:5.5, 'H2(l)-O2(l)'}, ...
    {'CH4(L)', 'O2(L)', 112, 90, 2.5:dOF:3.6, 'CH4(l)-O2(l)'}, ...
    {'RP-1', 'O2(L)', 298.15, 90, 2.0:dOF:3.1, 'RP1-O2(l)'}, ...
    {'CH6N2(L)', 'N2O4(L)', 298.15, 298.15, 1.2:dOF:2.5, 'MMH-NTO'}, ...
    {'CH6N2(L)', 'IRFNA', 298.15, 298.15, 1.8:dOF:2.9, 'MMH-RFNA'}, ...
    };
% CEA_settings = { ...
%     {'CH6N2(L)', 'N2O4(L)', 298.15, 298.15, 1.2:dOF:2.5, 'MMH-NTO'}, ...
%     {'CH6N2(L)', 'IRFNA', 298.15, 298.15, 1.8:dOF:2.9, 'MMH-RFNA'}, ...
%     {'CH6N2(L)', {'N2O4(L)', 'N2O3'}, 298.15, [298.15, 298.15], ...
%         1.4:dOF:2.6, [49.3, 50.7], 'MMH-MON25'}, ...
%     };

figure('Position', [200, 200, 400, 300]);
hold on;
xlabel('O/F');
ylabel('Isp (s)');
leg = {};
for i = 1:length(CEA_settings)
    inp = containers.Map;
    inp('type') = 'eq fr';              % Sets the type of CEA calculation
    inp('p') = 100;                     % Chamber pressure
    inp('sup') = 60;                    % Area ratio
    inp('p_unit') = 'psi';              % Chamber pressure units
    inp('o/f') = CEA_settings{i}{5};    % Mixture ratio
    inp('fuel') = CEA_settings{i}{1};   % Fuel name from thermo.inp
    inp('fuel_t') = CEA_settings{i}{3};
    inp('ox') = CEA_settings{i}{2};     % Ox name from thermo.inp
    inp('ox_t') = CEA_settings{i}{4};
    if iscell(CEA_settings{i}{2})
        inp('ox_wt%') = CEA_settings{i}{6};
    end

    % Call the CEA MATLAB code
    data = cea_rocket_run(inp);

    % Pull out equilibrium and frozen solutions
    data_eq = data('eq');
    data_fr = data('fr');
    
    % Calculate equilibrium and frozen flow averaged Isp
    ivac = squeeze((data_eq('ivac') +  data_fr('ivac')) / 2);
    
    % Calculate chamber temperature
    T = squeeze(data_eq('t'));

    % Plot Isp
    plot(inp('o/f'), ivac(:, 2) / 9.807, 'LineWidth', 2);
    leg{i} = CEA_settings{i}{end};
end
legend(leg, 'Location', 'northwest');