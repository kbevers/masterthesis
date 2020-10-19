close all; clear all

load('../mat/EUCinterped.mat');
load('../mat/discret.mat');
c = load('../mat/coastUTM.mat');

figA = twoColumnFig;

ha = tight_subplot(2, 1, 0.07, [0.08 0.05], [0.05 0.02]);


imagesc(Xmin:hf:Xmax, Ymax:-hf:Ymin, EUC_UCLC, 'parent', ha(1))
axis(ha(1), 'xy', 'equal');

hold(ha(1), 'on');
plot(ha(1), c.X, c.Y, '-', 'color', [0.5 0.5 0.5])
cb(1) = colorbar('peer', ha(1), 'location', 'EastOutside');
ylabel(cb(1), '[km]');
xlim(ha(1), [Xmin Xmax])
ylim(ha(1), [Ymin Ymax])
caxis(ha(1), [10 50])


imagesc(Xmin:hf:Xmax, Ymax:-hf:Ymin, EUC_MOHO, 'parent', ha(2))
axis(ha(2), 'xy', 'equal');
hold(ha(2), 'on');
plot(ha(2), c.X, c.Y, '-', 'color', [0.5 0.5 0.5])
cb(2) = colorbar('peer', ha(2), 'location', 'EastOutside');
ylabel(cb(2), '[km]');
xlim(ha(2), [Xmin Xmax])
ylim(ha(2), [Ymin Ymax])
caxis(ha(2), [10 50])



labelSubplots(figA, [1 1 1])
%set(cb(2), 'ycolor', [1 1 1])
saveFig(figA);

figB = twoColumnFig;


ha = tight_subplot(2, 1, 0.07, [0.08 0.05], [0.05 0.02]);


imagesc(Xmin:hf:Xmax, Ymax:-hf:Ymin, EUC_UC, 'parent', ha(1))
axis(ha(1), 'xy', 'equal');

hold(ha(1), 'on');
plot(ha(1), c.X, c.Y, '-', 'color', [0.5 0.5 0.5])
cb(1) = colorbar('peer', ha(1), 'location', 'EastOutside');
ylabel(cb(1), '[km/s]');
xlim(ha(1), [Xmin Xmax])
ylim(ha(1), [Ymin Ymax])
caxis(ha(1), [6 7.5])


imagesc(Xmin:hf:Xmax, Ymax:-hf:Ymin, EUC_LC, 'parent', ha(2))
axis(ha(2), 'xy', 'equal');
hold(ha(2), 'on');
plot(ha(2), c.X, c.Y, '-', 'color', [0.5 0.5 0.5])
cb(2) = colorbar('peer', ha(2), 'location', 'EastOutside');
ylabel(cb(2), '[km/s]');
xlim(ha(2), [Xmin Xmax])
ylim(ha(2), [Ymin Ymax])
caxis(ha(2), [6 7.5])

saveFig(figB)