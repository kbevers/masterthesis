% Creates figures that shows depth sections of the 3D model
clear all; close all;

addpath('../');
load('../mat/stationList.mat');
load('../mat/discret.mat');
c = load('../mat/coastUTM.mat');

depths = [1 11 21 31 41 51 61 71 81 91 101 111]; % indices to depths: 0, 10, 20, 30, 40, 50
%depths = 66:5:91;
h = zeros(size(depths));

for a=1:2
    b(a) = twoColumnFig(22);
    hb = tight_subplot(3,2, [0.001 0.03], [0.04 0.02], [0.08 0.01]);
    
    for j=1:6
        z = depths(j + 6*(a-1));
        
        file3d = '../bin/3DMDL/MUD/fin/P/vel.mod';
        disc1d = '../bin/3DMDL/MUD/fin/P/disc.mat';
        d = load(disc1d);
        
        v3 = xyslice(z, d.nx, d.ny, d.nz, file3d);
        
        V = v3 / 1000;
        
        imagesc(Xmin:hf:Xmax, Ymax:-hf:Ymin, V, 'parent', hb(j))
        axis(hb(j), 'xy', 'equal', 'tight');
        hold(hb(j), 'on');
        plot(hb(j), c.X, c.Y, '-', 'color', [0.5 0.5 0.5]);
        title(hb(j), sprintf('z = %dkm',(z*500-500)/1000));
        colorbar('peer', hb(j));
        
        if a == 1
            %caxis(hb(j), [2 max(V(:))]);
            if j == 1 || j == 2
                caxis(hb(j), [2 7]);
            else
                caxis(hb(j), [5.5 7]);
            end
        elseif a == 2
            %caxis(hb(j), [5 max(V(:))]);
            caxis(hb(j), [6 8]);
        end
        
        set(hb(j), 'xticklabel', {})
        set(hb(j), 'yticklabel', {})
        
        %colormap(french(25,3));
        
    end

end

saveFig(b(1))
saveFig(b(2))4