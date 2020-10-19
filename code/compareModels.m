clear all; close all;

c = load('mat/coastUTM.mat');
load('mat/discret.mat');
load('mat/stationList.mat');

view = 'res';
model1 = 'GEUS';
model3 = '3DMDL';
res = 'fin';
station = 'MUD';
phase = 'P';

% XY-views in two different models.
figA = twoColumnFig(7);

xi = [stations{1,2} 1.8e5];
yi = [stations{1,3} 6.16e6];

ha = tight_subplot(1,2,0.06, [0.04 0.04], [0.04 0.05]);

[fileStr3, d3] = visual_binfile(view, model3, station, res, phase);
T3 = xyslice(3, d3.nx, d3.ny, d3.nz, fileStr3) * d3.tmax / 32766;

[fileStr3, d1] = visual_binfile(view, model1, station, res, phase);
T1 = xyslice(3, d1.nx, d1.ny, d1.nz, fileStr3) * d1.tmax / 32766;

plot(ha(1),c.X, c.Y, '-', 'color', [0.5 0.5 0.5])
hold(ha(1), 'on')
contour(ha(1), Xmin:hf:Xmax, Ymax:-hf:Ymin, T1, 0:5:120, 'k-')
plot(ha(1), xi, yi, 'x-');

axis(ha(1), 'xy');
axis(ha(1), 'equal');
xlim(ha(1), [Xmin 5.5e5]);
ylim(ha(1), [Ymin 6.3e6]);
set(ha(1), 'xticklabel', []);
set(ha(1), 'yticklabel', []);

plot(ha(2),c.X, c.Y, '-', 'color', [0.5 0.5 0.5])
hold(ha(2), 'on')
contour(ha(2), Xmin:hf:Xmax, Ymax:-hf:Ymin, T3, 0:5:120, 'k-')
plot(ha(2), xi, yi, 'x-');

axis(ha(2), 'xy');
axis(ha(2), 'equal');
xlim(ha(2), [Xmin 5.5e5]);
ylim(ha(2), [Ymin 6.3e6]);
set(ha(2), 'xticklabel', []);
set(ha(2), 'yticklabel', []);




labelSubplots;

figB = twoColumnFig(11);
hb = tight_subplot(2,1, 0.06, [0.06 0.04], [0.04 0.05]);
if 0
    [V T C XI] = slice2D(model3, station, res, phase, xi, yi);
    s1.V = V; s1.T = T; s1.c = C; s1.XI = XI;
    save('mat/comp-s1.mat', 's1');
    
    [V T C XI] = slice2D(model1, station, res, phase, xi, yi);
    s2.V = V; s2.T = T; s2.c = C; s2.XI = XI;
    save('mat/comp-s2.mat', 's2');
else
    load('mat/comp-s1.mat');
    load('mat/comp-s2.mat');
end

%X = (size(s1.V,2)-1)*0.5:-0.5:0;
X = 0:0.5:(size(s1.V,2)-1)*0.5;
Z = 0:0.5:60;

imagesc(X, Z, s2.V, 'parent', hb(1));
hold(hb(1), 'on')
%plot(hb(2), s2.c(1,:), s2.c(2,:), '-w')
[c,h] = contour(hb(1), X, Z, s2.T, 0:5:120, '-w', 'linewidth', 1.5);
clabel(c,h, 'color', [1 1 1], 'labelspacing', 300);
caxis(hb(1),[2 8])
axis(hb(1), 'ij');
axis(hb(1), 'image');
ylim(hb(1), [0 60]);
%xlim(hb(2), X(end));
set(hb(1), 'xdir', 'reverse');



imagesc(X, Z, s1.V, 'parent', hb(2));
hold(hb(2), 'on')
%plot(hb(1), s1.c(1,:), s1.c(2,:), '-w')


[c,h] = contour(hb(2), X, Z, s1.T, 0:5:120, '-w', 'linewidth', 1.5);
clabel(c,h, 'color', [1 1 1], 'labelspacing', 300);
caxis(hb(2),[2 8])
axis(hb(2), 'ij');
axis(hb(2), 'image');
ylim(hb(2), [0 60]);
%xlim(hb(1), sort(xi));
%set(hb(1), 'yticklabel', [0 20 40 60]);
%set(hb(1), 'xticklabel', []);
set(hb(2), 'xdir', 'reverse');




labelSubplots;

saveFig(figA);
saveFig(figB);