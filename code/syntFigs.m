clear all;
close all;

load('mat/discret.mat');
c = load('mat/coastUTM.mat');
DB = 'TESTA';
mdl = 'GEUS';
sigma = 0.2; % error

% CALCULATED ERRORS. sigma = 02. R = sigma * randn(6,1);
% Hardwired in SEISAN S-files (DB: TESTA)
R = [-0.3423;
     -0.0204;
     -0.0483;
      0.0638;
      0.0626;
     -0.1730];


S = [Xmin+55*hc Ymin+45*hc 0];
q = syn_3Darrivals(S, 'fin',mdl);

[Y, X] = meshgrid(Ymax:-hc:Ymin, Xmin:hc:Xmax);

% LOCATE
useP = 1; useS = 1;
excludePstations = {'COP','SNART','BSD', 'KONO'};
excludeSstations = {'COP','SNART','BSD', 'KONO'};
verbose = 1;

q.setup.model = mdl; 
q.setup.weigthed = 1;
q.setup.fixed_depth = NaN; % in km OR NaN for free depth determination
q.setup.Sweigth = 1; % Value to weigth S-arrivals OR NaN for no S-weigths

qs1 = locate(q, useP, useS, excludePstations, excludeSstations, verbose);

excludePstations = {'SNART','BSD', 'KONO'};
excludeSstations = {'SNART','BSD', 'KONO'};

qs2 = locate(q, useP, useS, excludePstations, excludeSstations, verbose);


V = datevec(q.picks{9,3});
V(6) = V(6) + sigma*randn(1);
q.picks{9,3} = datenum(V);

V = datevec(q.picks{10,3});
V(6) = V(6) + sigma*randn(1);
q.picks{10,3} = datenum(V);

qs3 = locate(q, useP, useS, excludePstations, excludeSstations, verbose);

% LOAD SYNTHETIC SEISAN QUAKE
qS = SEISAN_get_quake('20030906', DB);

qS.setup = q.setup;
qS.setup.fixed_depth = 0;

qS = locate(qS, useP, useS, excludePstations, excludeSstations, verbose);


% SYNTHETIC SEISAN QUAKES WITH NOISE

qS1 = SEISAN_get_quake('20031204', DB);
qS1.setup = q.setup;
qS1 = locate(qS1, useP, useS, excludePstations, excludeSstations, verbose);

qS2 = SEISAN_get_quake('20031205', DB);
qS2.setup = q.setup;
qS2 = locate(qS2, useP, useS, excludePstations, excludeSstations, verbose);

qS3 = SEISAN_get_quake('20040416', DB);
qS3.setup = q.setup;
qS3 = locate(qS3, useP, useS, excludePstations, excludeSstations, verbose);

% SYNTHETIC SEISAN QUAKE WITH WRONG PHASE-READINGS

% HFS
qPg1 = SEISAN_get_quake('20050203', DB);
qPg1.setup = q.setup;
qPg1 = locate(qPg1, useP, useS, excludePstations, excludeSstations, verbose);

% MUD
qPg2 = SEISAN_get_quake('20050408', DB);
qPg2.setup = q.setup;
qPg2 = locate(qPg2, useP, useS, excludePstations, excludeSstations, verbose);

% COP
qPg3 = SEISAN_get_quake('20081216', DB);
qPg3.setup = q.setup;
qPg3 = locate(qPg3, useP, useS, excludePstations, excludeSstations, verbose);

% HFS, MUD, COP
qPg4 = SEISAN_get_quake('20100219', DB);
qPg4.setup = q.setup;
qPg4 = locate(qPg4, useP, useS, excludePstations, excludeSstations, verbose);

%%

cLevels = 1:1:60;
xLim = [5e5 8e5];
yLim = [6.35e6 6.6e6];


% FIGUR: EIK3D løsning med 2 stationer, EIK3D med 3 stationer
%        Forward: EIK3D
figA = twoColumnFig(9);
ha1 = tight_subplot(1,2, 0.02, [0.03 0.03], [0.04 0.04]);

axes(ha1(1));

plot(c.X, c.Y, '-', 'color', [0.5 0.5 0.5]);
hold on
[c1, h1] = contour(X,Y,qs1.locate.cruT_rms_img,cLevels,'-k');
%[c1, h1] = contour(X,Y,squeeze(qs1.locate.cruTrms(:,:,2)),cLevels,'-k');
clabel(c1,h1,2:2:60);

plot(S(1), S(2), 'r+', 'markersize', 10, 'linewidth', 2);
plot(qs1.locate.x, qs1.locate.y, 'bx', 'markersize', 10, 'linewidth', 2);

axis image;
xlim(xLim);
ylim(yLim);
set(ha1(1),'XTickLabel',[])
set(ha1(1),'YTickLabel',[])

axes(ha1(2));

plot(c.X, c.Y, '-', 'color', [0.5 0.5 0.5]);
hold on
[c2, h2] = contour(X,Y,qs2.locate.cruT_rms_img,cLevels,'-k');
clabel(c2,h2,2:2:60);
plot(S(1), S(2), 'r+', 'markersize', 10, 'linewidth', 2);
plot(qs2.locate.x, qs2.locate.y, 'bx', 'markersize', 10, 'linewidth', 2);

axis image;
xlim(xLim);
ylim(yLim);
set(ha1(2),'XTickLabel',[])
set(ha1(2),'YTickLabel',[])

labelSubplots(figA);

% FIGUR: SEISAN/EIK3D løsning med tre stationer
%        Forward: SEISAN
figB = twoColumnFig;

hold on

%plot(S(1), S(2), 'r+', 'markersize', 10, 'linewidth', 2);

plot(qS.utmx, qS.utmy, 'kx','markersize', 10, 'linewidth', 2);


plot(qS1.locate.x, qS1.locate.y, 'b+', 'markersize', 10, 'linewidth', 1);
plot(qS1.utmx, qS1.utmy, 'bo','markersize', 10, 'linewidth', 1);
[ex, ey, C, sx, sy] = determineContour(qS1,'xy');
plot(ex,ey,'b-')
plot(sx,sy,'b--');

plot(qS2.locate.x, qS2.locate.y, 'r+', 'markersize', 10, 'linewidth', 1);
plot(qS2.utmx, qS2.utmy, 'ro','markersize', 10, 'linewidth', 1);
[ex, ey, C, sx, sy] = determineContour(qS2,'xy');
plot(ex,ey,'r-')
plot(sx,sy,'r--');

plot(qS3.locate.x, qS3.locate.y, 'g+', 'markersize', 10, 'linewidth', 1);
plot(qS3.utmx, qS3.utmy, 'go','markersize', 10, 'linewidth', 1);
[ex, ey, C, sx, sy] = determineContour(qS3,'xy');
plot(ex,ey,'g-')
plot(sx,sy,'g--');


axis equal
%ylim([6.452e6 6.462e6])
%xlim([6.54e5 6.67e5]);
xlim([-7500 7500]+S(1));
ylim([-7500 7500]+S(2));
grid on
box on

% FIGUR: SEISAN løsninger med forkerte phaser.

figC = twoColumnFig(13);

plot(c.X, c.Y, '-', 'color', [0.5 0.5 0.5]);
hold on
%plot(S(1), S(2), 'kx', 'markersize', 10, 'linewidth', 2);

plot(qS.utmx, qS.utmy, 'k+', 'linewidth', 1);
%[~, ~, ~, sx, sy] = determineContour(qS);
[sx,sy,~,~] = errorEllipse(qS, 0);
plot(sx,sy,'k-');

plot(qPg1.utmx, qPg1.utmy, 'b+', 'linewidth', 1);
%[~, ~, ~, sx, sy] = determineContour(qPg1);
[sx,sy,~,~] = errorEllipse(qPg1, 0);

plot(sx,sy,'b-');

plot(qPg2.utmx, qPg2.utmy, 'r+', 'linewidth', 1);
%[~, ~, ~, sx, sy] = determineContour(qPg2);
[sx,sy,~,~] = errorEllipse(qPg2, 0);
plot(sx,sy,'r-');

plot(qPg3.utmx, qPg3.utmy, 'g+', 'linewidth', 1);
%[~, ~, ~, sx, sy] = determineContour(qPg3);
[sx,sy,~,~] = errorEllipse(qPg3, 0);
plot(sx,sy,'g-');

plot(qPg4.utmx, qPg4.utmy, 'm+', 'linewidth', 1);
%[~, ~, ~, sx, sy] = determineContour(qPg4);
[sx,sy,~,~] = errorEllipse(qPg4, 0);
plot(sx,sy,'m-');

axis image

xlim([-5e4 5e4]+S(1));
ylim([-3e4 2e4]+S(2));
grid on
box on

saveFig(figA);
saveFig(figB);
saveFig(figC);