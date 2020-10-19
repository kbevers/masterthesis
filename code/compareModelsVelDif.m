% Creates figures that show travel time differences in GEUS' 1D model and
% the 3D model
%%
clear all; close all;

load('mat/stationList.mat');
load('mat/discret.mat');
C = load('mat/coastUTM.mat');

% SNART cross-sections
d = [90 45];
s = [1 -1];
x = [stations{6,2} stations{6,2}];
y = [stations{6,3} stations{6,3}];
%x = [3.9e5 3.2e5];
%y = [6.47e6 6.54e6];

L = [150.5e3 300.5e3];

xs = [x;
    x+s.*cosd(d).*L];
ys = [y;
    y-s.*sind(d).*L];

% COP cross-sections

d = [45];
s = [1];
x = [stations{2,2}];
y = [stations{2,3}];
L = [300.5e3];

% x = [7.4e5 7.8e5];
% y = [6.19e6 6.3e6];

xc = [x;
    x+s.*cosd(d).*L];
yc = [y;
    y+s.*sind(d).*L];

% xc = [7.4e5 8.5e5;
%       7.8e5 9e5];
% yc = [6.19e6 6.3e6;
%       6.24e6 6.35e6];
%

%% Overviews

%depths = [1 21 41 61 81 121]; % indices to depths: 0, 10, 20, 30, 40, 50
depths = [1 41];

h = zeros(size(depths));
stats = [2 6];

figA = twoColumnFig;
ha = tight_subplot(2,2, [0.01 0.04], [0.03 0.02], [0.05 0.03]);
colormap(french(51,3));

k = 1; % subplot counter, used when changing axes

for j=1:length(depths);
    z = depths(j);
    
    for l=1:length(stats)
        
        i = stats(l);
        file1d = ['bin/GEUS/' stations{i,1} '/fin/P/fd01.times'];
        file3d = ['bin/3DMDL/' stations{i,1} '/fin/P/fd01.times'];
        
        disc1d = ['bin/GEUS/' stations{i,1} '/fin/P/disc.mat'];
        d = load(disc1d);
        
        t1 = xyslice(z, d.nx, d.ny, d.nz, file1d) .* d.tmax/32766;
        t3 = xyslice(z, d.nx, d.ny, d.nz, file3d) .* d.tmax/32766;
        
        T = t3-t1;
        
        %axes(ha(i));
        
        imagesc(Xmin:hf:Xmax, Ymax:-hf:Ymin, T, 'parent', ha(k))
        axis(ha(k), 'xy', 'equal', 'tight');
        hold(ha(k), 'on');
        plot(ha(k), C.X, C.Y, '-', 'color', [0.5 0.5 0.5]);
        plot(ha(k), stations{i,2}, stations{i,3}, 'kx', ...
            'markersize', 10, 'linewidth', 2);
        
        if l == 1
            % COP
            plot(ha(k), xc, yc, 'kx-')
        else
            % SNART
            plot(ha(k), xs, ys, 'kx-');
        end
        
        caxis(ha(k), [-2 2]);
        cb = colorbar('peer', ha(k));
        ylabel(cb, '[s]');
        title(ha(k), [stations{i,1} ' = ' num2str((z-1) * 0.5) ' km' ]);
        
        k = k + 1; %increase subplot counter
        
    end
end

labelSubplots;
%saveFig(figA);

%% Slices

%return

if 0 % Skip slow calculations
    
    Sc = struct('V1', cell(2,1), 'V3', cell(2,1), 'T1', cell(2,1), 'T3', cell(2,1), ...
        'c1', cell(2,1), 'c3', cell(2,1));
    
    Ss = struct('V1', cell(2,1), 'V3', cell(2,1), 'T1', cell(2,1), 'T3', cell(2,1), ...
        'c1', cell(2,1), 'c3', cell(2,1));
    
    for i=1:size(xc,2)
        station = 'COP';
        res = 'fin';
        phase = 'P';
        
        [V3, T3, c3, XI3] = slice2D('3DMDL', station, res, phase, xc(:,i), yc(:,i));
        [V1, T1, c1, XI1] = slice2D('GEUS', station, res, phase, xc(:,i), yc(:,i));

        
        Sc(i).V1 = V1;
        Sc(i).V3 = V3;
        Sc(i).T1 = T1;
        Sc(i).T3 = T3;
        Sc(i).c1 = c1;
        Sc(i).c3 = c3;

        
        save('mat/compSlicesCOP.mat', 'Sc');
    end
    
    for i=1:size(xs,2)
        station = 'SNART';
        res = 'fin';
        phase = 'P';
        
        [V3, T3, c3, XI3] = slice2D('3DMDL', station, res, phase, xs(:,i), ys(:,i));
        [V1, T1, c1, XI1] = slice2D('GEUS', station, res, phase, xs(:,i), ys(:,i));
        V3 = fliplr(V3); V1 = fliplr(V1);
        T3 = fliplr(T3); T1 = fliplr(T1);
        
        Ss(i).V1 = V1;
        Ss(i).V3 = V3;
        Ss(i).T1 = T1;
        Ss(i).T3 = T3;
        Ss(i).c1 = c1;
        Ss(i).c3 = c3;

        
        save('mat/compSlicesSNART.mat', 'Ss');
    end
    
else
    
    load('mat/compSlicesSNART.mat'); % Ss
    load('mat/compSlicesCOP.mat');   % Sc
    
    cm = 8;
    
    figs(1) = twoColumnFig(cm); % COP 0-150 km
    figs(2) = twoColumnFig(cm); % SNART1 0-150 km
    figs(3) = twoColumnFig(cm); % SNART2 0-150 km
    figs(4) = twoColumnFig(cm); % COP 150-300 km
    figs(5) = twoColumnFig(cm); % SNART2 150-300 km
    
    
    figure(figs(1));
    XI = 0:0.5:(size(Sc(1).V1, 2)-1)*0.5;
    imagesc(XI, 0:0.5:60, Sc(1).V3-Sc(1).V1);
    colormap(flipud(french(51,3)));
    %colorbar;
    hold 'on';
    
    [c, hh] = contour(XI, 0:0.5:60, Sc(1).T3, 0:2:150, '-m', 'linewidth', 1.5);
    clabel(c,hh, 'LabelSpacing', 300, 'color', 'm');
    [c,hh] = contour(XI, 0:0.5:60, Sc(1).T1, 0:2:150, '-k', 'linewidth', 1.5);
    clabel(c,hh, 'LabelSpacing', 144, 'color', 'k');
    
    caxis([-1 1])
    axis('ij', 'image');
    
    % copy to another figure
    copyobj(get(figs(1),'children'),figs(4));
    
    for i = 1:2
        figure(figs(1 + i))
        XI = 0:0.5:(size(Ss(i).V1, 2)-1)*0.5;
        imagesc(XI, 0:0.5:60, Ss(i).V3-Ss(i).V1);
        colormap(flipud(french(51,3)));
        %colorbar;
        hold 'on';
        
        [c, hh] = contour(XI, 0:0.5:60, Ss(i).T3, 0:2:150, '-m', 'linewidth', 1.5);
        clabel(c,hh, 'LabelSpacing', 300, 'color', 'm');
        [c,hh] = contour(XI, 0:0.5:60, Ss(i).T1, 0:2:150, '-k', 'linewidth', 1.5);
        clabel(c,hh, 'LabelSpacing', 144, 'color', 'k');
        
        caxis([-1 1])
        axis('ij', 'image');
        set(gca, 'xtick', 0:50:max(XI)+0.5);
        set(gca, 'Xticklabel', fliplr(0:50:max(XI)+0.5));
        
        
    end
    
    copyobj(get(figs(3),'children'),figs(5));
    %copyobj(allchild(figs(3)),figs(5));
    
    % Fine-tune figures (limits etc)
    
    figure(figs(1)); % First COP cross-section
    xlim([0 150]);
    %colorbar;
    
    figure(figs(4)); % Second COP cross-section
    caxis([-1 1])
    colormap(flipud(french(51,3)));
    %colorbar;
    xlim([150 300]);
    
    figure(figs(3)); % first SNART2 cross-section
    xlim([0 150]);
    %colorbar;
    
    figure(figs(5)); % second SNART2 cross-section
    colormap(flipud(french(51,3)));
    %colorbar;
    xlim([150 300]);
    
    figure(figs(2)); % SNART1 cross-section
    %colorbar;
end


saveFig(figA);
saveFig(figs(1));
saveFig(figs(2));
saveFig(figs(3));
saveFig(figs(4));
saveFig(figs(5));







