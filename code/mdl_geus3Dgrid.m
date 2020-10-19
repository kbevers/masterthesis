% Constructs 3D P and S wave velocity grids from the 1D velocity model GEUS
% uses.
% 
% --------------- z0 = 0
%  v1 = 6.07 km/s
% --------------- z1 = 15km
%  v2 = 6.64 km/s
% --------------- z2 = 40km
%  v3 = 8.03 km/s
%

clear all;
close all;
load('mat/model.mat');
load('mat/discret.mat');


% === INITIAL DEFINITIONS === %

% cell sizes ( from discret.mat/loadData )
%hc = hc2/1000;    % course grid, km - one crude cell is equal to 20 fine cells
%hm = hm/1000;    % medium grid, km - one medium cell is equal to 4 fine cells
%hf = hf/1000;    % fine grid, km

Z  = Zmax / 1000;           % Depth to bottom of grid
Vmantle = Vmantle/1000;   % Fixed mantle velocity, km/s

% allocate memory
%[M,N] = size(TPZ_V);
%P = Z/hf;

M = length(Ymin:hf:Ymax);
N = length(Xmin:hf:Xmax);
P = length(Zmin:hf:Zmax) + Zpadding;

% MAKE THIS ONE OR TWO LAYERS BIGGER IN -Z-DIRECTION
V = zeros(N,M,P, 'int16');

% depth indeces

z1 = 15000/hf + Zpadding;
z2 = 40000/hf + Zpadding;
v1 = 6070;
v2 = 6640;
v3 = 8030;


V(:,:,1:z1) = v1;
V(:,:,z1+1:z2) = v2;
V(:,:,z2+1:end) = v3;


save('mat/V_GEUS_fin_P.mat', 'V');

% determine S-velocities
V = V./PSratio;
save('mat/V_GEUS_fin_S.mat', 'V');