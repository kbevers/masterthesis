% REGRIDDING TPZ DATA!!
clear all;
load TPZ.mat
load discret.mat

N = length(TPZ_X);

minX = min(TPZ_X(1:N));
maxX = max(TPZ_X(1:N));
minY = min(TPZ_Y(1:N));
maxY = max(TPZ_Y(1:N));

% regrid TPZ data
[X,Y] = meshgrid(Xmax:-500:Xmin, Ymax:-500:Ymin);
[M,N] = size(X);
V = zeros(size(X));
D = zeros(size(X));

tic
Ni = length(TPZ_X);

for i=1:Ni

    I = find(X == TPZ_X(i) & Y == TPZ_Y(i));
    V(I) = TPZ_V(i);
    D(I) = TPZ_D(i);

    if mod(i, 1000) == 0
        fprintf('Progress: %d of %d\n', i, Ni);
        toc
    end

end

clear 'TPZ_*';

TPZ_X = fliplr(X);
TPZ_Y = fliplr(Y);
TPZ_D = -fliplr(D)/1000;
TPZ_V = fliplr(V)/1000;

save('TPZ_grid.mat', 'TPZ_*');
