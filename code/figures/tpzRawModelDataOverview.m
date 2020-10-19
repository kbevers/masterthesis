close all; clear all

load('../mat/TPZ_grid.mat');
load('../mat/discret.mat');
c = load('../mat/coastUTM.mat');

figA = twoColumnFig(15);

ha = tight_subplot(2, 1, 0.07, [0.08 0.05], [0.05 0.02]);

%cm = flipud(hot);
cm = jet(200);

cm(1,:) = [1 1 1].*0;
colormap(cm);

imagesc(Xmin:hf:Xmax, Ymax:-hf:Ymin, TPZ_D, 'parent', ha(1))
axis(ha(1), 'xy', 'equal');

hold(ha(1), 'on');
plot(ha(1), c.X, c.Y, '-', 'color', [0.5 0.5 0.5])
cb(1) = colorbar('peer', ha(1), 'location', 'EastOutside');
ylabel(cb(1), '[km]');
xlim(ha(1), [Xmin 10.5e5])
ylim(ha(1), [Ymin 6.55e6])



imagesc(Xmin:hf:Xmax, Ymax:-hf:Ymin, TPZ_V, 'parent', ha(2))
axis(ha(2), 'xy', 'equal');
hold(ha(2), 'on');
plot(ha(2), c.X, c.Y, '-', 'color', [0.5 0.5 0.5])
cb(2) = colorbar('peer', ha(2), 'location', 'EastOutside');
ylabel(cb(2), '[km/s]');
xlim(ha(2), [Xmin 10.5e5])
ylim(ha(2), [Ymin 6.55e6])



labelSubplots(figA, 'left', [1 1 1])
%set(cb(2), 'ycolor', [1 1 1])
saveFig(figA);