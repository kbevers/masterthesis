close all; clear all;
c = load('mat/coastUTM.mat');
figA = twoColumnFig;

% load explosion data
mdl = '3DMDL';
db = 'ORIG_';

path = ['locations/' mdl '/' db '/'];

load([path '20031204124749.mat']); q3 = q;
load([path '20031204132821.mat']); q4 = q;
load([path '20050203154947.mat']); q7 = q;

% convert from lat/lon to utm

eLat = [56.167 56.1673 56.255];
eLon = [11.392 11.5028 11.470];

m_proj('utm', 'zone', 32, 'lon', [3 20], ...
    'lat', [54 61], 'hemisphere', 0, 'ellipse', 'wgs84');

[eX eY] = m_ll2xy(eLon, eLat);


% plot solutions
plot(c.X, c.Y, '-', 'color', [0.5 0.5 0.5]);
hold on
plot(eX(1), eY(1), 'kp', 'markersize', 10, 'linewidth', 2);
plot(eX(2), eY(2), 'kp', 'markersize', 10, 'linewidth', 2);

text(eX(1)-2000, eY(1)-2000, '3 & 4')
text(eX(2)-500, eY(2)-2000, '7')

%xlim([6.4 6.6]*1e5)5
%ylim([6.22 6.24]*1e6);

% explosion 3

plot(q3.utmx, q3.utmy, 'b+', q3.locate.x, q3.locate.y, 'bx', ...
    'markersize', 10, 'linewidth', 2);

plot(q4.utmx, q4.utmy, 'r+', q4.locate.x, q4.locate.y, 'rx', ...
    'markersize', 10, 'linewidth', 2);

plot(q7.utmx, q7.utmy, 'g+', q7.locate.x, q7.locate.y, 'gx', ...
    'markersize', 10, 'linewidth', 2);

axis equal;
grid on;
xlim([6.05 6.8]*1e5);
ylim([6.205 6.265]*1e6);

% determine distances from locations to sources

de3 = sqrt( (eX(1) - q3.locate.x)^2 + (eY(1) - q3.locate.y)^2);
de4 = sqrt( (eX(1) - q4.locate.x)^2 + (eY(1) - q4.locate.y)^2);
de7 = sqrt( (eX(2) - q7.locate.x)^2 + (eY(2) - q7.locate.y)^2);

ds3 = sqrt( (eX(1) - q3.utmx)^2 + (eY(1) - q3.utmy)^2);
ds4 = sqrt( (eX(1) - q4.utmx)^2 + (eY(1) - q4.utmy)^2);
ds7 = sqrt( (eX(2) - q7.utmx)^2 + (eY(2) - q7.utmy)^2);

dist = [de3 ds3;
        de4 ds4;
        de7 ds7];
disp(dist./1000)

 plot(eX(3), eY(3), 'go', 'markersize', 10, 'linewidth', 2); 
 
 sqrt( (eX(2) - eX(3))^2 + (eY(2) - eY(3))^2) ./ 1000
 %sqrt( (eX(2) - eX(4))^2 + (eY(2) - eY(4))^2) ./ 1000

saveFig(figA);

