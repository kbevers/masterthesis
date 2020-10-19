% CALL:     function [img, c] = slice2D(mdl, station, res, phase, xi, yi)
%
% DESCR:    Interpolates 2D cross-section in given model along a line
%           from (x1,y1) to (x2, y2).
%
% INPUT:    mdl, model
%           station, ...
%           res, 'cru' or 'fin'
%           phase, 'P' or 'S'
%           xi, [x1 x2]
%           yi, [y1 y1]
%
% OUTPUT:   V, 2D-array of model
%           T, 2D-array of traveltimes
%           c, contours off traveltimes
%           XI, x-values for given slice

function [V, S, c, XI] = slice2D(mdl, station, res, phase, xi, yi)

load('mat/discret.mat');
load('mat/stationList.mat');


[f d] = visual_binfile('res', mdl, station, res, phase);
[fv ~] = visual_binfile('mod', mdl, station, res, phase);

nx = d.nx; ny = d.ny; nz = d.nz;

h = getNodeSpacing(res);

X = Xmin:h:Xmax;
Y = Ymax:-h:Ymin;

% number of interpolation-points (distance from (x1,y1) to (x2,y2) divided
% by node-spacing

ni = round( sqrt(diff(xi).^2 + diff(yi).^2) / h ); 

XI = linspace(xi(1), xi(2), ni);
YI = linspace(yi(1), yi(2), ni);

%plot(X, Y, '-x')

V = zeros(nz-2,ni);
S = zeros(nz-2,ni);

for i=1:nz-2
    
    M = xyslice(i,nx,ny,nz, fv) ./ 1000;
    V(i,:) = interp2(X, Y, M, XI, YI, 'linear');
    
    T = xyslice(i,nx,ny,nz, f) .* d.tmax/32766;
    S(i,:) = interp2(X, Y, T, XI, YI, 'linear');
    disp(i);
end


nc = 50;
c = contourc(XI, 0:h:60e3, S, nc);

j = 0;
I = 1;

while j < nc
    
    n = c(2,I);
    c(:,I);
    c(:,I) = NaN;
    I = I + n + 1;
    j = j + 1;
end

% make sure that there's no bad points in the contours
I = find(c(2,:) < 500 & c(1,:) < 500); 
c(:, I) = NaN;


