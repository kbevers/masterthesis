close all; clear all

t = load('../mat/TPZ_grid.mat');
load('../mat/TPZinterped.mat');
load('../mat/discret.mat');
load('../mat/I.mat');
c = load('../mat/coastUTM.mat');

a = I > 0;

figA = twoColumnFig(7.5);

ha = tight_subplot(1, 2, 0.02, [0.07 0.08], [0.05 0.02]);

cm = jet(200); 

cm(1,:) = [1 1 1];
colormap(cm);

limits = [2.5e5 4e5 6.38e6 6.5e6];

imagesc(Xmin:hf:Xmax, Ymax:-hf:Ymin, t.TPZ_D, 'parent', ha(1))
axis(ha(1), 'xy', 'equal');
hold(ha(1), 'on');
plot(ha(1), c.X, c.Y, '-', 'color', [0.5 0.5 0.5])
plot(ha(1), TPZ_X(a), TPZ_Y(a), 'r.', 'markersize', 12)

%cb(1) = colorbar('peer', ha(1), 'location', 'eastoutside');
%ylabel(cb(1), '[km]');
caxis([0 max(TPZ_D(:))])
axis(ha(1),limits)


imagesc(Xmin:hf:Xmax, Ymax:-hf:Ymin, TPZ_D, 'parent', ha(2))
axis(ha(2), 'xy', 'equal');
hold(ha(2), 'on');
plot(ha(2), c.X, c.Y, '-', 'color', [0.5 0.5 0.5])
plot(ha(2), TPZ_X(a), TPZ_Y(a), 'r.', 'markersize', 12)
%cb(2) = colorbar('peer', ha(2), 'location', 'Eastoutside');
%ylabel(cb(2), '[km/s]');
axis(ha(2),limits)


labelSubplots(figA, 'right');
saveFig(figA);