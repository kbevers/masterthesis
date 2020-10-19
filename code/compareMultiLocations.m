function fig = compareMultiLocations(seisanDB, eikModel, zoom, explosion)

% VARIABLES FOR TESTING PURPOSES
%close all;
%seisanDB = 'ORIG_';
%eikModel = '3DMDL';
%zoom = 1;

c = load('mat/coastUTM.mat');
load('mat/discret.mat');

fig = twoColumnFig;
%set(fig, 'papersize', [18 13]);
papersize = get(fig, 'PaperSize');
scale = papersize(2)/papersize(1);

% limits of map-view
if zoom
    xMin = 5.6e5;
    xMax = 7.3e5;
    yMin = 6.2e6;
    zMin = Zmin-10000;
    zMax = Zmax-15000;
else
    xMin = 3.2e5;
    xMax = 8.2e5;
    yMin = 6.1e6;
    zMin = Zmin-20000;
    zMax = Zmax+20000;
end

yMax = yMin + (xMax-xMin)*scale;


Lx = xMax - xMin;
Ly = yMax - yMin;
Lz = zMax - zMin;

% !!! SET UP FIGURE PROPERTIES !!! %
xy = axes; hold on; % create axis for XY-plot
yz = axes; hold on; % create axis for YZ-plot
xz = axes; hold on; % create axis for XY-plot

% define distances
if zoom
    xOffset = 0.07;
    yOffset = 0.08;
    bigWidth = 0.65;
    space = 0.02;
else
    xOffset = 0.07;
    yOffset = 0.08;
    bigWidth = 0.71;
    space = 0.02;
end

xzHeight = Lz/Lx*bigWidth;
yzHeight = Lz/Ly*bigWidth*scale;

% [left bottom width height]
set(xz, 'position', [xOffset yOffset bigWidth xzHeight]);
set(xy, 'position', [xOffset yOffset+xzHeight+space bigWidth bigWidth]);
set(yz, 'position', [xOffset+bigWidth+space yOffset+xzHeight+space yzHeight bigWidth]); 


% XY
grid(xy, 'on');
ylabel(xy,'y [m]');
ylim(xy, [yMin yMax]);
xlim(xy, [xMin xMax]);
box(xy,'on');
set(xy, 'xticklabel', []);

% YZ
ylim(yz,[yMin yMax]);
xlim(yz,[zMin zMax]);
set(yz, 'yticklabel', [])
box(yz, 'on');
set(yz, 'xtick', [0 30 60]*1e3);
set(yz, 'xticklabel', [0 30 60])
grid(yz, 'on');
xlabel('z [km]');

% XZ
axis(xz,'ij');
ylim(xz,[zMin zMax]);
xlim(xz,[xMin xMax]);
box(xz, 'on')
set(xz, 'ytick', [0 30 60]*1e3);
set(xz, 'yticklabel', [0 30 60])
grid(xz, 'on');
ylabel(xz,'z [km]');
xlabel(xz,'x [m]');


% List of quakes
path = ['locations/' eikModel '/' seisanDB '/'];
l = dir([path '*.mat']);

eLine = '-';
sLine = '-';
eMark = 'x';
sMark = '+';
colors = lines(length(l));

% !!! START PLOTTING !!! %
plot(xy,c.X, c.Y, '-', 'color', [0.5 0.5 0.5]);

resStr = '';

for i=1:length(l)

    load([path l(i).name]); % load q from disk
    
    if q.utmx < xMin || q.utmx > xMax
        continue;
    end
    
    if q.utmy < yMin || q.utmy > yMax
        continue;
    end
    
    if explosion && ~q.explosion
        continue;
    end
    
    % XY PLANE
    plot(xy, q.utmx, q.utmy, sMark, 'color', colors(i,:));
    plot(xy, q.locate.x, q.locate.y, eMark, 'color', colors(i,:));
    tx = text(q.utmx+2000, q.utmy, num2str(i));
    set(tx, 'parent', xy);
    
    [xe, ye, ~, xs, ys] = determineContour(q, 'xy');
    plot(xy, xe, ye, eLine, 'color', colors(i,:));
    plot(xy, xs, ys, sLine, 'color', colors(i,:));
    [~, iDot] = max(ye);
    plot(xy, xe(iDot), ye(iDot), '.', 'markersize', 12, 'color', colors(i,:));
    
    
    % XZ PLANE
    plot(xz,q.utmx, q.dep*1000, sMark, 'color', colors(i,:));
    plot(xz, q.locate.x, q.locate.z, eMark, 'color', colors(i,:));
    
    [xe, ye, ~, xs, ys] = determineContour(q, 'xz');
    plot(xz, xs, ys, sLine, 'color', colors(i,:));
    plot(xz, xe, ye, eLine, 'color', colors(i,:));
    [~, iDot] = min(ye);
    plot(xz, xe(iDot), ye(iDot), '.', 'markersize', 12, 'color', colors(i,:));
    
    % YZ PLANE
    plot(yz, q.dep*1000, q.utmy, sMark, 'color', colors(i,:));
    plot(yz, q.locate.z, q.locate.y, eMark, 'color', colors(i,:));
    
    [xe, ye, ~, xs, ys] = determineContour(q, 'yz');
    plot(yz, xs, ys, sLine, 'color', colors(i,:));
    plot(yz, xe, ye, eLine, 'color', colors(i,:));
    [~, iDot] = min(ye);
    plot(yz, xe(iDot), ye(iDot), '.', 'markersize', 12, 'color', colors(i,:));
    
    resStr = sprintf('%s%d   %2.2f   %2.2f\n', resStr, i, q.timeRMS, q.locate.minResidual);
    
end

disp(resStr);


saveFig(fig);

