% Defines basic model parameters
clear all;

% model boundaries
latMin = 54;
latMax = 61;
lonMin = 3;
lonMax = 20;

hf = 500;
hm = 2000;
hc = 10000;

m_proj('utm', 'zone', 32, 'lon', [lonMin lonMax], ...
            'lat', [latMin latMax], 'hemisphere', 0, 'ellipse', 'wgs84');
        
[utmXmin, utmYmin] = m_ll2xy(lonMin, latMin);
[utmXmax, utmYmax] = m_ll2xy(lonMax, latMax);

% mantle velocity
Vmantle = 8030; % [km/h]

% number of padding nodes above z=0
Zpadding = 2;

PSratio = 1.73;

save('mat/model.mat');
