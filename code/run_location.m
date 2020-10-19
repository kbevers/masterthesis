%close all;
clear all; close all;
load('mat/stationList.mat');
load('mat/discret.mat');

res = 'cru';
h = getNodeSpacing(res);

% SETTINGS

%S = [598353.03 6401482.78 0]; % skagen
%S = [599500    6401500      0]; % tæt på skagen
%S = [598000     6108000     0];
%S = [Xmin+72*h+0 Ymin+43*h+0 h];
%S = [Xmin+13*h+0 Ymin+23*h+0 0];

% RAMMER VED SIDEN AF
 S = [Xmin+55*h Ymin+45*h 0]; % x=3, y=-2
%  S = [Xmin+55*h Ymin+45*h 0]; % x=3, y=-2
% S = [Xmin+34*h+500 Ymin+40*h+4000 0]; % x=-3, y=1

% --------------------- SEISAN ------------------------
DB = 'ORIG_';
mdl = '3DMDL';

% time = '20030822034938';
% time = '20030906004249';
% time = '20031204124749'; % Offshore Djursland
% time = '20031204132821'; % Kattegat
% time = '20040223083826'; % Køge bugt
% time = '20040928115341';  % 
% time = '20050203154947'; % Udelad MUD. Dårligere bestemt end SEISAN
% time = '20050408161132'; % Samme residual som SEISAN - GODT EKSEMPEL I 1D-MODEL
time = '20081216052002'; % Skåne
% time = '20100219210700'; % Hanstholm

% KUN TO STATIONER:
% time = '20040416081116'; % Kun HFS, og BSD til rådighed.

q = SEISAN_get_quake(time, DB);

% ------------- 1D SYNTHETICS, GEUS MODEL -------------
v = [6.07 6.64 8.03];
z = [15 40];
%q1 = syn_1Darrivals(S, stations, z, v);
%save('mat/syn_1d.mat', 'q1');
%load('mat/syn_1d.mat');

% -------------- 3D SYNTHETICS MODEL ------------------
%q = syn_3Darrivals(S, 'fin',mdl); % BRUG DET FINE NET!


% LOCATE
useP = 1; useS = 1;
excludePstations = {'KONO','SNART','HFS'};
excludeSstations = {'KONO','HFS'};
verbose = 1;

q.setup.model = mdl; 
q.setup.weigthed = 1;
q.setup.fixed_depth = NaN; % in km OR NaN for free depth determination
q.setup.Sweigth = 1; % Value to weigth S-arrivals OR NaN for no S-weigths

q = locate(q, useP, useS, excludePstations, excludeSstations, verbose);


% PLOT
s.coastline = 1;
s.contours = 0;
s.uncertainty = 1;
s.location = 1;
s.residuals = 1;
s.zoom = 1;
[figA, ax] = plotQ(q,s);
%title(ax, ['3D-mode: ' q.setup.model]);
ylim(ax(1),[6.0 6.8]*1e6)
saveFig(figA);
