close all; clear all; clc;
inp = containers.Map;

addpath('..\');

inp('file_name')='PBAN_SSRM.inp';
inp('type') = 'fr';
inp('p') = 660;
inp('p_unit') = 'psi';
inp('sup')=7.5;
inp('fuel') = {'AL', 'NH4CLO4(I)', 'PBAN'};
inp('fuel_wt%') = [16 70 14];
inp('fuel_t') = [298 298 298];
inp('fuel_t_unit') = 'K';

data = cea_rocket_run(inp);
eq=data('eq');
c_star=squeeze(eq('cstar'));
T=squeeze(eq('t'));
P=squeeze(eq('p'));
Pc=P(1);
Pe=P(2);
gamma=squeeze(eq('gammas'));
gam=gamma(2);
mach=squeeze(eq('mach'));