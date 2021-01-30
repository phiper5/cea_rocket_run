addpath('..\');

CEA_settings = { ...
    {'H2(L)', 'O2(L)', 20, 90, 3.6:0.01:3.9}, ...
    {'H2(L)', 'O2(L)', 20, 90, 6}, ...
    {'CH4(L)', 'O2(L)', 112, 90, 2.9:0.01:3.2}, ...
    {'CH4(L)', 'O2(L)', 112, 90, 3.5}, ...
    {'RP-1', 'O2(L)', 298.15, 90, 2.3:0.01:2.5}, ...
    {'N2H4(L)', 'N2O4(L)', 298.15, 298.15, 1.1:0.01:1.3}, ...
    {'CH6N2(L)', 'N2O4(L)', 298.15, 298.15, 1.6:0.01:2.0}, ...
    {'C2H8N2(L),UDMH', 'N2O4(L)', 298.15, 298.15, 2:0.01:2.4}, ...
    {'syntin', 'O2(L)', 298.15, 90, 1.9:0.01:2.2}, ...
    {'B2H6(L)', 'O2(L)', 181, 90, 1.6:0.01:1.9}, ...
    {'B5H9(L)', 'O2(L)', 298.15, 90, 1.7:0.01:2.0}, ...
    {'B2H6(L)', 'F2(L)', 181, 85, 5.2:0.01:5.5}, ...
    {'B5H9(L)', 'F2(L)', 298.15, 85, 4.7:0.01:5.1}, ...
    {'CH6N2(L)', 'IRFNA', 298.15, 298.15, 2.2:0.01:2.5}, ...
    {'CH6N2(L)', {'N2O4(L)', 'N2O3'}, 298.15, [298.15, 298.15], ...
        1.8:0.01:2.1, [49.3, 50.7]}, ...
    {'CH6N2(L)', 'CLO3F(L)298', 298.15, 298.15, 1.9:0.01:2.2}, ...
    {'H2(L)', 'F2(L)', 20, 85, 5.5:0.01:5.8}, ...
    {'H2(L)', 'F2O(L)', 20, 128, 4.5:0.01:4.8}, ...
    {'B5H9(L)', 'F2(L)', 298, 85, 4.6:0.01:5.0}, ...
    {'B5H9(L)', 'CLF3(L)298', 298, 298, 8:0.01:8.4}, ...
    {'B5H9(L)', 'CLF5(L)298', 298, 298, 7.0:0.01:7.3}, ...
    {'H2(L)', 'O3(L)', 20, 161, 3.2:0.01:3.4}, ...
    };

for i = 1:length(CEA_settings)
    inp = containers.Map;
    inp('type') = 'eq fr';              % Sets the type of CEA calculation
    inp('p') = 1000;                    % Chamber pressure
    inp('pip') = 1000 / 14.7;           % Pressure ratio
    inp('p_unit') = 'psi';              % Chamber pressure units
    inp('o/f') = CEA_settings{i}{5};    % Mixture ratio
    inp('fuel') = CEA_settings{i}{1};   % Fuel name from thermo.inp
    inp('fuel_t') = CEA_settings{i}{3};
    inp('ox') = CEA_settings{i}{2};     % Ox name from thermo.inp
    inp('ox_t') = CEA_settings{i}{4};
    if length(CEA_settings{i}) > 5
        inp('ox_wt%') = CEA_settings{i}{6};
    end

    % Call the CEA MATLAB code
    data = cea_rocket_run(inp);

    % Pull out equilibrium and frozen solutions
    data_eq = data('eq');
    data_fr = data('fr');
    
    % Calculate equilibrium and frozen flow averaged Isp
    isp = squeeze((data_eq('isp') +  data_fr('isp')) / 2);
    
    % Calculate chamber temperature
    T = squeeze(data_eq('t'));
    
    % Prop string
    if length(CEA_settings{i}) > 5
        ox_name = [CEA_settings{i}{2}{1}, '/', CEA_settings{i}{2}{2}];
    else
        ox_name = CEA_settings{i}{2};
    end
    props = [CEA_settings{i}{1}, '-', ox_name];

    % Multiple O/Fs means search for optimal Isp O/F
    if length(CEA_settings{i}{5}) > 1
        % Calculate optimal Isp
        [Isp_max, i_max] = max(isp(:, 2));
        cell_print{i} = {CEA_settings{i}{5}(i_max), ...
            round(Isp_max / 9.807), round(T(i_max)), props};
    
        % Plot Isp
        figure;
        plot(inp('o/f'), isp(:, 2) / 9.807);
        xlabel('O/F');
        ylabel('Isp (s)');
        title(props);
    else
        cell_print{i} = {CEA_settings{i}{5}, ...
            round(isp(2) / 9.807), round(T(1)), props};
    end
end

% Print results
for i = 1:length(cell_print)
    fprintf('O/F: %.2f\tIsp: %i\tTc: %i\t%s\n', cell_print{i}{:});
end