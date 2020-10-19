clear all; close all;
addpath('../../');

writeBinaries = false;

X = 200; Y = 400; Z = 50;
h = 0.5; % cell-spacing

nx = X/h+1; ny = Y/h+1; nz = Z/h+1;

tmax = 100; % seconds, used in nfd-calculations. Use same value as in f.in

Sx = 10;
Sy = 10;

Nsources = 1;

bx1 = 50; bx2 = 100;
by1 = 50; by2 = 100;
bz1 = 40; bz2 = 45;

x1 = round(bx1/h) + 1; x2 = round(bx2/h) + 1;
y1 = round(by1/h) + 1; y2 = round(by2/h) + 1;
z1 = round(bz1/h) + 1; z2 = round(bz2/h) + 1;

if writeBinaries
    V = zeros(nx,ny,nz);
    
    z1 = round(15/h) + 1;
    z2 = round(40/h) + 1;
    
    
    V(:,:,1:z1)     = 6070;  % first layer 0-15km (upper crust)
    V(:,:,z1+1:z2)  = 6640; % second layer 15-40km (lower crust)
    V(:,:,z2+1:end) = 8030; % third layer 40-50km (moho)
    
    Vw = V;
    
    % introduce a slow block beneath moho at x=350km-390km, y=50km-100km
    % z=40km-45km
    
    x1 = round(bx1/h) + 1; x2 = round(bx2/h) + 1;
    y1 = round(by1/h) + 1; y2 = round(by2/h) + 1;
    z1 = round(bz1/h) + 1; z2 = round(bz2/h) + 1;
    
    nfd_writeBinary('normal/vel.mod',V);
    V(x1:x2,y1:y2,z1:z2) = 6640;
    nfd_writeBinary('block/vel.mod', V);
    
    for i=x1:x2
        
        for j=1:(i-x1+1)
            j = y1 + j;
            Vw(i,j,z1:z2) = 6640;
            
        end
    end
        
    nfd_writeBinary('wedge/vel.mod', Vw);
    
end

clear V;
clear Vw;

% read arrival times from binary files
T_normal = zeros(nx,ny,nz,Nsources);
T_block  = zeros(nx,ny,nz,Nsources);
T_wedge  = zeros(nx,ny,nz,Nsources);

for i=1:Nsources % read times from N sources
    
    f1 = sprintf('normal/fd%02d.times', i);
    f2 = sprintf('block/fd%02d.times', i);
    f3 = sprintf('wedge/fd%02d.times', i);
    
    T_normal(:,:,:,i) = nfd_readRawBinfile(f1,nx,ny,nz);
    T_block (:,:,:,i) = nfd_readRawBinfile(f2,nx,ny,nz);
    T_wedge (:,:,:,i) = nfd_readRawBinfile(f3,nx,ny,nz);
end

T_normal = T_normal * tmax/32766;
T_block = T_block * tmax/32766;
T_wedge = T_wedge * tmax/32766;

%%

z = z1 + 1;


figA = twoColumnFig;


ha = tight_subplot(1, 2, [0.04 0.04], [0.04 0.04], [0.04 0.02]);

%for src=1:Nsources
    %subplot(2,3,src);
src = 1;
    img = T_block(:,:,z,src) - T_normal(:,:,z,src);
    img = img';
    imagesc(0:h:X, 0:h:Y, img, 'Parent', ha(1));
    axis(ha(1), 'xy')
    axis(ha(1), 'equal', 'tight')
    hold(ha(1), 'on')
    plot(ha(1), Sx(src), Sy(src), 'kx', 'markersize', 8, 'linewidth', 2);
    
    % plot slow box
    plot(ha(1), [x1 x2 x2 x1 x1]*h-h, [y2 y2 y1 y1 y2]*h-h, '-k');
    colormap(french(25,3))
    caxis(ha(1), [-1 1])
    
    title(ha(1), '(a)');
    
%end


%ha = tight_subplot(1, 1, [0.04 0.04], [0.04 0.04], [0.04]);

%for src=1:Nsources
 
src = 1;

    img = T_wedge(:,:,z,src) - T_normal(:,:,z,src);
    img = img';
    imagesc(0:h:X, 0:h:Y, img, 'Parent', ha(2)); colorbar('peer', ha(2));
    axis(ha(2), 'xy')
    axis(ha(2), 'equal', 'tight')
    hold(ha(2), 'on')
    plot(ha(2), Sx(src), Sy(src), 'kx', 'markersize', 8, 'linewidth', 2);
    
    % plot slow box
    plot(ha(2), [x1 x2 x2 x1 ]*h-h, [y1 y2 y1 y1]*h-h, '-k');
    colormap(french(25,3))
    caxis(ha(2), [-1 1])
    
    title(ha(2), '(b)');
    
    
%end

saveFig(figA);
