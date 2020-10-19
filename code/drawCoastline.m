% Creates a mat-file with UTM-coordinates of coastline in the model-area.
clear all; close all;

% get boundaries of area
load('mat/model.mat');

% setup projection
m_proj('utm', 'zone', 32, 'lon', [lonMin lonMax], ...
    'lat', [latMin latMax], 'hemisphere', 0, 'ell', 'wgs84');

% get coastline in lat/lon
m_gshhs_i('save', 'mat/coastUTM');
load('mat/coastUTM.mat');

x = ncst(:,1); y = ncst(:,2);

% get rid of unwanted coastline from greenland (bug in m_gshhs?)
I = find( (x > lonMin & x < lonMax & y > latMin & y < latMax) ...
    | isnan(x) | isnan(y) );
x = x(I); y = y(I);

% Manually fixes a run-away line
a = 521;
x(a) = NaN; y(a) = NaN;

% convert to UTM coordinates
[X,Y] = m_ll2xy(x,y);

save('mat/coastUTM', 'X', 'Y');

