% Tests similarity of 1D models used in test calculations with SEISAN
%
close all; clear all;

% Define models
Vg = [6070 6640 8030   ]./1000;
Zg = [   0   15   40 80];

Vs = [6200 6600 7100 8050 8250   ]./1000;
Zs = [   0   12   23   31   50 80];

Va = [2950 6300 6844 8000   ]./1000;
Za = [   0 3.21 21.8 34.8 80];

%theta = 90:-5:10;
theta = 20;
x = [-10 500];

fig = twoColumnFig;


% plot models in different colors
plot(x, Zg'*ones(1,2), 'r', 'linewidth', 2);
hold on
plot(x, Zs'*ones(1,2), 'b', 'linewidth', 2);
plot(x, Za'*ones(1,2), 'm', 'linewidth', 2);

% plot boundaries, surface (0km) and mantle (80km)
plot(x, [0 0], 'k', 'linewidth', 2);
plot(x, [80 80], 'k', 'linewidth', 2);

axis ij;
ylim([-5 85]); xlim([0 500]);

c = ['r', 'b', 'g'];

for i=1:length(theta)
    pg = sin(pi/180*theta(i))/Vg(1);
    ps = sin(pi/180*theta(i))/Vs(1);
    pa = sin(pi/180*theta(i))/Va(1);
    
    [Xg, tg] = vz2xt(pg, Vg, Zg, 'homog');
    [Xs, ts] = vz2xt(ps, Vs, Zs, 'homog');
    [Xa, ta] = vz2xt(pa, Va, Za, 'homog');
    
    [xg, zg] = xz2ray(Xg,Zg);
    [xs, zs] = xz2ray(Xs,Zs);
    [xa, za] = xz2ray(Xa,Za);
    
    plot(xg, zg, 'r');
    plot(xs, zs, 'b');
    plot(xa, za, 'm');
end

figure
plot(Xg, tg, '.-r')
hold on
plot(Xs, ts, '.-b')
plot(Xa, ta, '.-m')