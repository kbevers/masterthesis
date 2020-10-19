% The original TPZ data doesn't have any values where there's
% fault-lines. This script fixes that by interpolating values.

clear all; close all; clc;
load('mat/TPZ_grid.mat');
load('mat/I.mat');

% SETTINGS
interpMethod = 'linear'; % other options: nearest, spline, pchip, cubic

flaf = jet(200);
flaf(1,:) = [1 1 1];

[M,N] = size(TPZ_V);

A = twoColumnFig;
colormap(flaf);

subplot(2,1,1);
imagesc(TPZ_V); hold on; axis equal; spy(I,'r', 2); colorbar;
subplot(2,1,2);
imagesc(TPZ_D); hold on; axis equal; spy(I,'r', 2); colorbar;

TPZ_D = TPZ_D + 1;

for i=1:M       % for each column
    
    bounds = find(I(i,:) > 0);
    % fix zero-sequences
    %(if diff == 1, two points is placed next to each other)
    %Is = find(diff([bounds 0]) ~= 1);
    %bounds = bounds(Is);
    
    notZero = find(TPZ_V(i,:) ~= 0);

    
    for n=1:length(bounds)-1
        
        a = bounds(n);
        b = bounds(n+1);
        
        % interpolation not necessary i gaps
        if sum(TPZ_V(i,a+1:b-1)) == 0
            continue;
        end
        
        % first make sure that it is possible to interpolate
        % across gaps. 
        if TPZ_V(i,a) == 0
            TPZ_V(i,a) = interp1(notZero, TPZ_V(i,notZero), a, ...
                interpMethod, 'extrap');
            TPZ_D(i,a) = interp1(notZero, TPZ_D(i,notZero), a, ...
                interpMethod, 'extrap');
        end
        
        if TPZ_V(i,b) == 0
            TPZ_V(i,b) = interp1(notZero, TPZ_V(i,notZero), b, ...
                interpMethod, 'extrap');
            TPZ_D(i,b) = interp1(notZero, TPZ_D(i,notZero), b, ...
                interpMethod, 'extrap');
        end
        
        Ireal = a - 1 + find(TPZ_V(i,a:b) ~= 0);
        Inan  = a - 1 + find(TPZ_V(i,a:b) == 0);
        
        %         plot(a+Ireal, i,'rx');
        %plot(Inan, i, 'gx', 'markersize', 14, 'linewidth', 2);
        %2
        
        TPZ_V(i,Inan) = ...
            interp1(Ireal, TPZ_V(i,Ireal), Inan, interpMethod);
        TPZ_D(i,Inan) = ...
            interp1(Ireal, TPZ_D(i,Ireal), Inan, interpMethod);
    end
end

% create X and Y matrices

[TPZ_X, TPZ_Y] = meshgrid( min(TPZ_X(:)):500:max(TPZ_X(:)), ...
    max(TPZ_Y(:)):-500:min(TPZ_Y(:)));

Ixy = find(TPZ_V == 0);
TPZ_X(Ixy) = 0;
TPZ_Y(Ixy) = 0;

TPZ_D = TPZ_D - 1;

B = twoColumnFig;
subplot(2,1,1);
imagesc(TPZ_V); hold on; axis equal; colorbar;
spy(I,'r',2)
title('Velocity [km/s]');
colormap(flaf);

subplot(2,1,2)
imagesc(TPZ_D); hold on; axis equal; colorbar;
spy(I,'r',2)
title('Depth [km]');
colormap(flaf)

saveFig(A); saveFig(B);

save('mat/TPZinterped.mat', 'TPZ_*');
