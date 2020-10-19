% CALL:         tmap = nfd_readTimeMap(model, station, res, wave)
%
% INPUT:        model, velocity model
%               station, seismic station
%               res, resolution of grid
%               wave, do calculations on P or S wave
%
% OUTPUT:       tmap, 3D array with traveltimes. Single precision.
% 
%
% DESCR:        Reads calculated times from nfd.
%
% Kristian Evers, June 2011

function tmap = nfd_readTimeMap(model, station, res, wave)

load('mat/stationList.mat'); % var: stations
resolutions = {'cru', 'med', 'fin'};

n = find(strcmp(station, stations(:,1)),1);
if isempty(n)
    fprintf('%s is not a valid station\n', res);
    return;
end

if sum( strcmp(res, resolutions) ) ~= 1
    fprintf('%s is not a valid resolution\n', res);
    return
end

if sum( strcmp(wave, {'P', 'S'}) ) ~= 1
    fprintf('%s is not a valid wave-type\n', wave);
    return
end

dir = ['bin/' model '/' station '/' res '/' wave '/'];

load([dir 'disc.mat']);


t = zeros(nx,ny,nz,'uint16');

fin = [dir 'fd01.times'];

fid = fopen(fin,'r');
for k=1:nz
    %for j=ny:-1:1
    for j=1:ny
        fread(fid,1,'int32');
        t(:,j,k) = fread(fid, nx, 'int16=>uint16');
        fread(fid,1,'int32');
    end
end
fclose(fid);

%tmax = sqrt( (xmax-xmin)^2 + (ymax-ymin)^2 + (zmax-zmin)^2 )/(minV/1000);

tmap = single(t) .* single(tmax)/32766;
