clear all; close all;

load('../mat/TPZinterped.mat');
load('../mat/EUCinterped.mat');
load('../mat/discret.mat');
c = load('../mat/coastUTM.mat');

figHeight = 14;

%% FIGURE A
figA = twoColumnFig(figHeight);

imagesc(Xmin:500:Xmax, Ymax:-500:Ymin, TPZ_V);
axis xy;
axis equal;
hold on
plot(c.X, c.Y, '-', 'color', [0.5 0.5 0.5]);

axis([Xmin Xmax Ymin Ymax])

cm = jet(300);
cm(1,:) = 1;
colormap(cm);

caxis([1 5])
cb = colorbar;
ylabel(cb, '[km/s]');


%% FIGURE B
figB = twoColumnFig(figHeight);

imagesc(Xmin:500:Xmax, Ymax:-500:Ymin, TPZ_D);
axis xy;
axis equal;

hold on
plot(c.X, c.Y, '-', 'color', [0.5 0.5 0.5]);

axis([Xmin Xmax Ymin Ymax])

cm = jet(300);
cm(1,:) = 1;
colormap(cm);

caxis([0 9])
cb = colorbar;
ylabel(cb, '[km]');


%% FIGURE C
figC = twoColumnFig(figHeight);

imagesc(Xmin:500:Xmax, Ymax:-500:Ymin, EUC_UC);
axis xy;
axis equal;
hold on
plot(c.X, c.Y, '-', 'color', [0.5 0.5 0.5]);

axis([Xmin Xmax Ymin Ymax])

caxis([6 6.5])
cb = colorbar;
ylabel(cb, '[km/s]');

%% FIGURE D

figD = twoColumnFig(figHeight);

imagesc(Xmin:500:Xmax, Ymax:-500:Ymin, EUC_UCLC);
axis xy;
axis equal;
hold on
plot(c.X, c.Y, '-', 'color', [0.5 0.5 0.5]);

axis([Xmin Xmax Ymin Ymax])

caxis([10 40])
cb = colorbar;
ylabel(cb, '[km]');

%% FIGURE E
figE = twoColumnFig(figHeight);

imagesc(Xmin:500:Xmax, Ymax:-500:Ymin, EUC_LC);
axis xy;
axis equal;
hold on
plot(c.X, c.Y, '-', 'color', [0.5 0.5 0.5]);

axis([Xmin Xmax Ymin Ymax])

caxis([6.3 7.3001])
cb = colorbar;
ylabel(cb, '[km/s]');

%% FIGURE F
figF = twoColumnFig(figHeight);

imagesc(Xmin:500:Xmax, Ymax:-500:Ymin, EUC_MOHO);
axis xy;
axis equal;
hold on
plot(c.X, c.Y, '-', 'color', [0.5 0.5 0.5]);

axis([Xmin Xmax Ymin Ymax])

caxis([25 55])
cb = colorbar;
ylabel(cb, '[km]');

%% SAVE FIGS

saveFig(figA);
saveFig(figB);
saveFig(figC);
saveFig(figD);
saveFig(figE);
saveFig(figF);