% Creates figures that show travel time differences in GEUS' 1D model and
% the 3D model

clear all; close all;

addpath('../');
load('../mat/stationList.mat');
load('../mat/discret.mat');
c = load('../mat/coastUTM.mat');

depths = [1 21 41 61 81 121]; % indices to depths: 0, 10, 20, 30, 40, 50
h = zeros(size(depths));

for j=1:length(depths);
    z = depths(j);
    h(j) = a4Fig;
    colormap(french(51,3));
    ha = tight_subplot(3,2, [0.01 0.04], [0.03 0.02], [0.05 0.03]);
    
    for i=1:size(stations, 1)
        
        file1d = ['../bin/GEUS/' stations{i,1} '/fin/P/fd01.times'];
        file3d = ['../bin/3DMDL/' stations{i,1} '/fin/P/fd01.times'];
        
        disc1d = ['../bin/GEUS/' stations{i,1} '/fin/P/disc.mat'];
        d = load(disc1d);
        
        t1 = xyslice(z, d.nx, d.ny, d.nz, file1d) .* d.tmax/32766;
        t3 = xyslice(z, d.nx, d.ny, d.nz, file3d) .* d.tmax/32766;
        
        T = t3-t1;
        
        %axes(ha(i));
        
        imagesc(Xmin:hf:Xmax, Ymax:-hf:Ymin, T, 'parent', ha(i))
        axis(ha(i), 'xy', 'equal', 'tight');
        hold(ha(i), 'on');
        plot(ha(i), c.X, c.Y, '-', 'color', [0.5 0.5 0.5]);
        plot(ha(i), stations{i,2}, stations{i,3}, 'kx', ...
            'markersize', 10, 'linewidth', 2);
        caxis(ha(i), [-2 2]);
        colorbar('peer', ha(i));
        title(ha(i),stations{i,1});
        
        
        
    end
    %saveFig(h(j));
        
end
