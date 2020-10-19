% Script that tests the precision in traveltimes calculated with FAST and
% SEISAN (TTLAYER)
clear all; close all;

% LOAD TRAVELTIMES FROM FAST

load('bin/GEUS/BSD/fin/P/disc.mat')
T = xyslice(3, nx, ny,nz, 'bin/test/GEUS_fin_P.times') * tmax/32766;

[~, It] = min(T(:));
[J,I] = ind2sub(size(T), It); % indices to origin

% traveltimes calculated by FAST. 0-500km
t_fastP = T(J:1:J+800,I);

% LOAD TRAVELTIMES FROM SEISAN (TTLAYER)
M = load('txt/seisanTraveltimesPS.txt');
M = M(1:801,:);
x = M(:,1);
t_seisanP = M(:,2);
t_seisanS = M(:,3);

%plot(x, t_seisanP-t_fastP, 'k-')

i = 1:1:length(x);

t_percent = (t_seisanP(i) - t_fastP(i)) ./ t_seisanP(i) * 100;
t_diff = (t_seisanP(i) - t_fastP(i)) * 1000; % traveltime difference in miliseconds

figA = twoColumnFig;

subplot(3,2,3:6);
[ax, h1, h2] = plotyy(x(i), t_percent, x(i), t_diff);

ylabel(ax(1), 'relativ afgivelse [%]');
ylabel(ax(2), 'absolut afvigelse [ms]');

set(ax(1), 'ytick', [0 1 2 3 4]);
set(ax(2), 'ytick', [0 50 100 150 200]);

xlabel('Afstand fra kilde [km]');
grid on;

a = subplot(3,2, 1:2);

plot(x, t_seisanP-x/8, '-g', 'linewidth', 1);
hold on
plot(x, t_fastP-x/8, '--k', 'linewidth', 1);
ylabel('t - x/8');
grid on

set(a, 'Xticklabel', [])


saveFig(figA);

%%

figB = twoColumnFig;

M = load('txt/seisanTraveltimesPSinterp.txt');
x = M(:,1);
tP= M(:,2);

[X,Y] = meshgrid(0:0.5:980, 0:0.5:800);

R = sqrt((X - 490).^2 + (Y - 400).^2);

tInterp = interp1(x,tP,R(:));

tSEISAN = reshape(tInterp,size(X));

imagesc(-490:1:490, -400:1:400, (tSEISAN-T)*1000);
colormap(hsv)
c = colorbar;
caxis([-5 140])

axis equal;
axis tight;

xlabel('x [km]');
ylabel('y [km]');
ylabel(c,'[ms]');

saveFig(figB);