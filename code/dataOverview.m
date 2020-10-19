close all; clear all;
c = load('mat/coastUTM.mat');
load('mat/discret.mat');
SEISAN_quake_list

DB = 'ORIG_';
% DB = 'SEISA';
Xlim = [3.2e5 8.2e5];
Ylim = [6.1e6 6.45e6];
Zlim = [Zmin-20000, Zmax+20000];

figA = twoColumnFig(13);
set(figA, 'papersize', [18 13]);


% XY-plot
xy = subplot(3,3,[1 2 4 5]);

plot(c.X, c.Y, '-', 'color', [0.5 0.5 0.5]);
hold on
grid on
ylabel('y [m]');

xlim(Xlim);
ylim(Ylim);

% YZ-plot
yz = subplot(3,3,[3 6]);
hold on;


% XY-plot
xz = subplot(3,3,[7 8]);
hold on;
    
axes(xy);
for i=1:length(quakeList)

    q = SEISAN_get_quake(quakeList{i}, DB);
    
    if q.explosion
        col = [1 0 0];
    else
        col = [0 0 1];
    end
    
    plot(xy,q.utmx, q.utmy, 'x', 'color', col);
    text(q.utmx+2000, q.utmy, num2str(i));
    
    [xe, ye] = ellipseCrossSection(q, 'xy');
    plot(xe, ye,'-', 'color', col);
    
    plot(xz,q.utmx, q.dep*1000, 'x', 'color', col);
    [xe, ye] = ellipseCrossSection(q, 'xz');
    plot(xz, xe, ye,'-', 'color', col);
    
    plot(yz, q.dep*1000, q.utmy, 'x', 'color', col);
    [xe, ye] = ellipseCrossSection(q, 'yz');
    plot(yz, xe, ye,'-', 'color', col);
end


%set(xy, 'ytick', [])
set(xy, 'xticklabel', [])

axes(yz)

axis equal;
ylim(Ylim);
xlim(Zlim);
set(yz, 'yticklabel', [])
box on
set(yz, 'xtick', [0 30 60]*1e3);
set(yz, 'xticklabel', [0 30 60])
grid on
xlabel('z [km]');

axes(xz);

axis equal;
axis ij
ylim(Zlim);
xlim(Xlim);
box on
set(xz, 'ytick', [0 30 60]*1e3);
set(xz, 'yticklabel', [0 30 60])
grid on
ylabel('z [km]');
xlabel('x [m]');

posXY= get(xy, 'position');
posXZ= get(xz, 'position');
posYZ= get(yz, 'position');

%[left bottom width height]

%newXY = [0.08 0.05+posXZ(4) posXY(3) posXY(4)];
%newXZ = [0.08 0.05 posXZ(3) posXZ(4)];
%newYZ = [

bigWidth = 0.63; smallWidth = 0.25;

newXY = [0.08 0.30 bigWidth bigWidth];
newXZ = [0.08 0.06 bigWidth smallWidth];
newYZ = [0.02+bigWidth 0.30 smallWidth bigWidth];

set(xy, 'position', newXY);
set(xz, 'position', newXZ);
set(yz, 'position', newYZ);

saveFig(figA);



