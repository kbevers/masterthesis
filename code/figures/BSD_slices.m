%%
close all; clear all;


cd('../');
load('mat/stationList.mat');

mdl = '3DMDL';
station = 'BSD';
res = 'fin';
phase = 'P';

h = getNodeSpacing(res);

d = [44 48 53];
s = [-1 -1 -1];
x = [stations{3,2} stations{3,2} stations{3,2}];
y = [stations{3,3} stations{3,3} stations{3,3}];


L = [700.5e3 700.5e3 700.5e3];

xi = [x;
    x+s.*cosd(d).*L];
yi = [y;
    y-s.*sind(d).*L];

xi = xi'; yi = yi';

%xi = [stations{3,2} 1.8e5;
%      stations{3,2} 4e5;
%      stations{3,2} 2.8e5];

%yi = [stations{3,3} 6.8e6;
%      stations{3,3} 6.8e6;
%      stations{3,3} 6.8e6];

%%

% FAST 3D MODEL
[V1_3, T1_3, c1_3, XI1_3] = slice2D(mdl, station, res, phase, xi(1,:), yi(1,:));
[V1_1, T1_1, c1_1, XI1_1] = slice2D('GEUS', station, res, phase, xi(1,:), yi(1,:));

% SLOW 3D MODEL
[V2_3, T2_3, c2_3, XI2_3] = slice2D(mdl, station, res, phase, xi(2,:), yi(2,:));
[V2_1, T2_1, c2_1, XI2_1] = slice2D('GEUS', station, res, phase, xi(2,:), yi(2,:));

% NEUTRAL TIMES
[V3_3, T3_3, c3_3, XI3_3] = slice2D(mdl, station, res, phase, xi(3,:), yi(3,:));
[V3_1, T3_1, c3_1, XI3_1] = slice2D('GEUS', station, res, phase, xi(3,:), yi(3,:));

cd('figures/');


v = 5:5:150;

V1_3 = fliplr(V1_3); V1_1 = fliplr(V1_1);
V2_3 = fliplr(V2_3); V2_1 = fliplr(V2_1);
V3_3 = fliplr(V3_3); V3_1 = fliplr(V3_1);

T1_3 = fliplr(T1_3); T1_1 = fliplr(T1_1);
T2_3 = fliplr(T2_3); T2_1 = fliplr(T2_1);
T3_3 = fliplr(T3_3); T3_1 = fliplr(T3_1);

L1 = sqrt(diff(xi(1,:)).^2 + diff(yi(1,:)).^2) / 1000;
L2 = sqrt(diff(xi(2,:)).^2 + diff(yi(2,:)).^2) / 1000;
L3 = sqrt(diff(xi(3,:)).^2 + diff(yi(3,:)).^2) / 1000;


XI1_3 = linspace(L1,0,length(XI1_3));
XI2_3 = linspace(L2,0,length(XI2_3));
XI3_3 = linspace(L3,0,length(XI3_3));


%% PLOT

%save('BSDslice.mat');
load('BSDslice.mat');
close all;

%figA = a4Fig('l');
figA = figure;

%set(figA,'PaperOrientation','landscape');
set(figA, 'paperunits', 'centimeters');
set(figA, 'papersize', [25 13]);
set(figA, 'paperposition', [0 0 25 13]);

ha = tight_subplot(3, 1, 0.05, 0.05, [0.03 0.03]);

colormap(flipud(french(25,3)));


% FAST 3D MODEL
imagesc(XI1_3, 0:h/1000:60, V1_3-V1_1, 'parent', ha(1)); 
%colorbar('peer', ha(1));
hold(ha(1), 'on');

[c, hh] = contour(ha(1), XI1_3, 0:h/1000:60, T1_3, v, '-m', 'linewidth', 1.5);
clabel(c,hh, 'LabelSpacing', 300);
contour(ha(1), XI1_3, 0:h/1000:60, T1_1, v, '-', 'linewidth', 1.5, 'color', [0 0 0]);
plot(ha(1), [0 700], [50 50], '--k');

caxis(ha(1), [-1 1])
axis(ha(1), 'ij', 'image');
xlim(ha(1), [0 max([L1 L2 L3])])
title(ha(1),'(a)');


% SLOW 3D MODEL
imagesc(XI2_3, 0:h/1000:60, V2_3-V2_1, 'parent', ha(2)); 
%colorbar('peer', ha(2));
hold(ha(2), 'on');
[c, hh] = contour(ha(2), XI2_3, 0:h/1000:60, T2_3, v, '-m', 'linewidth', 1.5);
clabel(c,hh, 'LabelSpacing', 300);
contour(ha(2), XI2_3, 0:h/1000:60, T2_1, v,  '-', 'linewidth', 1.5, 'color', [0 0 0]);
plot(ha(2), [0 700], [50 50], '--k');

caxis(ha(2), [-1 1])
axis(ha(2), 'ij','image');
xlim(ha(2), [0 max([L1 L2 L3])])
title(ha(2), '(b)');


% NEUTRAL TIMES
imagesc(XI3_3, 0:h/1000:60, V3_3-V3_1, 'parent', ha(3)); 
%colorbar('peer', ha(3));
hold(ha(3), 'on');
[c, hh] = contour(ha(3), XI3_3, 0:h/1000:60, T3_3, v, '-m', 'linewidth', 1.5);
clabel(c,hh, 'LabelSpacing', 300);
contour(ha(3), XI3_3, 0:h/1000:60, T3_1, v,  '-', 'linewidth', 1.5, 'color', [0 0 0]);
plot(ha(3), [0 700], [50 50], '--k');

caxis(ha(3), [-1 1])
axis(ha(3), 'ij','image');
xlim(ha(3), [0 max([L1 L2 L3])])
title(ha(3), '(c)');


set([ha(1) ha(2) ha(3)], 'xdir', 'reverse');


saveFig(figA)


%% overview

figB = twoColumnFig;
addpath('../');
colormap(french(25,3));
c = load('../mat/coastUTM.mat');
load('../mat/discret.mat');
file1d = ['../bin/GEUS/' stations{3,1} '/fin/P/fd01.times'];
file3d = ['../bin/3DMDL/' stations{3,1} '/fin/P/fd01.times'];

disc1d = ['../bin/GEUS/' stations{3,1} '/fin/P/disc.mat'];
d = load(disc1d);

z = 101;

t1 = xyslice(z, d.nx, d.ny, d.nz, file1d) .* d.tmax/32766;
t3 = xyslice(z, d.nx, d.ny, d.nz, file3d) .* d.tmax/32766;

T = t3-t1;

%axes(ha(i));

imagesc(Xmin:hf:Xmax, Ymax:-hf:Ymin, T)
axis('xy', 'equal', 'tight');
hold on;
plot(c.X, c.Y, '-', 'color', [0.5 0.5 0.5]);
plot(stations{3,2}, stations{3,3}, 'kx', ...
    'markersize', 10, 'linewidth', 2);
caxis([-1 1]);
colorbar;
title(stations{3,1});


plot(xi(1,:), yi(1,:), 'x-');
plot(xi(2,:), yi(2,:), 'x-');
plot(xi(3,:), yi(3,:), 'x-');

text(xi(1,2)-25000, yi(1,2),'a');
text(xi(2,2)-25000, yi(2,2),'b');
text(xi(3,2)-25000, yi(3,2),'c');

saveFig(figB)


