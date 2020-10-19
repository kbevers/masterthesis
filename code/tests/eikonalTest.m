close all; clear all;
addpath('..');

dx = 0.5;
dz = 0.5;

z1 = 30;
z2 = 80;
v1 = 6;
v2 = 8;

X=-5:dx:300;
Z=-5:dz:z2;
V=ones(length(Z),length(X));

% indices to layer boundary and source
I = find(Z == 30);
I0 = find(Z == 0);

V(1:I,:) = v1;
V(I+1:end,:) = v2;

% eikonal løsning
tmap = fast_fd_2d(X,Z,V,[0,0]);
fast_fd_clean;

figA = twoColumnFig;
contour(X,Z,tmap, 40, '-k');
axis equal;
hold on
plot([X(1) X(end)], [0  0 ], '-r');
plot([X(1) X(end)], [z1 z1], '-r');
plot([X(1) X(end)], [z2 z2], '-r');
colorbar
axis ij


% x-t diagram
figB = oneColumnFig;
% cross-over distance

% adjust vertical layer boundary to match the one used in fast_fd_2d
z1 = z1 + dz/2;
x_co = 2*z1 * ( (v2 + v1) / (v2 - v1) )^0.5;
% direct wave
t = X / v1;
% refracted wave
t2 = ( (2*z1) / (v1*v2) ) * ( v2^2 - v1^2)^0.5 + X / v2;

plot(X, tmap(6,:), 'linewidth', 2);
hold on
plot([x_co x_co], [0 50], 'k');
plot(X, t, '--r', 'linewidth', 2)
plot(X, t2, '--g', 'linewidth', 2)
grid on


figC = oneColumnFig;
% vis forskel på eikonal-løsning og stråle-løsningen
plot(X, t-tmap(I0,:), 'b');
hold on
plot(X, t2-tmap(I0,:), 'k');
grid on

tile_figs
saveFig(figA);