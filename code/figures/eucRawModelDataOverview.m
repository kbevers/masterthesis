clear all; close all;

%
% 
% data_path = '/Users/kristianevers/Documents/uni/Speciale/data/sedimentmodel/';
% EuCRUST07_path = [data_path 'EuCRUST07/'];
% 
% EuCRUST07_file = '2007gl032244-ds01_MOD.txt';
% EuCRUST07 = load([EuCRUST07_path EuCRUST07_file]);
% 
% EUC_X = reshape(EuCRUST07(:,1),242,36058/242)';
% EUC_Y = reshape(EuCRUST07(:,2),242,36058/242)';
% EUC_UC = reshape(EuCRUST07(:,3),242,36058/242)';
% EUC_LC = reshape(EuCRUST07(:,4),242,36058/242)';
% EUC_BASE = reshape(EuCRUST07(:,7),242,36058/242)';
% EUC_UCLC = reshape(EuCRUST07(:,8),242,36058/242)';
% EUC_MOHO = reshape(EuCRUST07(:,9),242,36058/242)';
% 
%  save('../data/EUC_Raw.mat', 'EUC_X', 'EUC_Y', 'EUC_UC', 'EUC_LC', ...
%      'EUC_UCLC', 'EUC_MOHO');

load('../data/EUC_Raw.mat');
m_proj('Miller', 'lon', [EUC_X(1,1) EUC_X(1,end)], 'lat', [EUC_Y(1,1) EUC_Y(end,1)]);
m_gshhs_c('save', '../data/eurocoast.mat');
load('../data/eurocoast.mat');
I = find(ncst(:,1) > -50 | isnan(ncst(:,1)));
X = ncst(I,1); Y = ncst(I,2);
save('../data/eurocoast.mat', 'X', 'Y');

load('../data/EUC_Raw.mat');
c = load('../data/eurocoast.mat');

figA = twoColumnFig;
ha = tight_subplot(2, 2, 0.06, [0.05 0.02], [0.05 0.01]); 

subplot(ha(1));
imagesc(EUC_X(1,:), EUC_Y(:,1), EUC_UCLC)
axis xy
hold on
plot(c.X, c.Y, 'k-');
cb = colorbar('location', 'west');
colormap(flipud(hot));
caxis([0 65]);
ylabel(cb,'[km]');

subplot(ha(2));
imagesc(EUC_X(1,:), EUC_Y(:,1), EUC_MOHO)
axis xy
hold on
plot(c.X, c.Y, 'k-');
cb = colorbar('location', 'west');
caxis([0 65]);
ylabel(cb,'[km]');

subplot(ha(3));
imagesc(EUC_X(1,:), EUC_Y(:,1), EUC_UC)
axis xy
hold on
plot(c.X, c.Y, 'k-');
cb = colorbar('location', 'west');
caxis([4.5 8.5]);
ylabel(cb,'[km/s]');

subplot(ha(4));
imagesc(EUC_X(1,:), EUC_Y(:,1), EUC_LC)
axis xy
hold on
plot(c.X, c.Y, 'k-');
cb = colorbar('location', 'west');
caxis([4.5 8.5]);
ylabel(cb,'[km/s]');

%labelSubplots(figA, 'right');
saveFig(figA);

figB = twoColumnFig;
ha = tight_subplot(2, 2, 0.06, [0.05 0.02], [0.05 0.01]); 

subplot(ha(1));
imagesc(EUC_X(1,:), EUC_Y(:,1), EUC_UCLC)
axis xy
hold on
plot(c.X, c.Y, 'k-');
cb = colorbar('location', 'west');
colormap(jet);
caxis([0 65]);
ylabel(cb,'[km]');

subplot(ha(2));
imagesc(EUC_X(1,:), EUC_Y(:,1), EUC_MOHO)
axis xy
hold on
plot(c.X, c.Y, 'k-');
cb = colorbar('location', 'west');
caxis([0 65]);
ylabel(cb,'[km]');

subplot(ha(3));
imagesc(EUC_X(1,:), EUC_Y(:,1), EUC_UC)
axis xy
hold on
plot(c.X, c.Y, 'k-');
cb = colorbar('location', 'west');
caxis([5 8]);
ylabel(cb,'[km/s]');

subplot(ha(4));
imagesc(EUC_X(1,:), EUC_Y(:,1), EUC_LC)
axis xy
hold on
plot(c.X, c.Y, 'k-');
cb = colorbar('location', 'west');
caxis([5 8]);
ylabel(cb,'[km/s]');

%t = labelSubplots(figB, 'right');
saveFig(figB);



