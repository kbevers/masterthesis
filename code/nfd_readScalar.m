% CALL:         X = nfd_readScalar(I, J, K, model, station, res, phase)
%
% INPUT:        I, x-index
%               J, y-index
%               K, z-index
%               model, velocity model
%               station, station-code
%               res, resolution [cru|med|fin]
%               phase, [P|S]
%               scale, 1=scale with tmax, 0=raw value from binary. Default
%               is 1.
%
% OUTPUT:       X, value at coordinate (I,J,K)
%
% DESCR:        Reads a single value from a 'fd01.times'-file (defined by
%               station, res & phase)



function X = nfd_readScalar(I, J, K, model, station, res, wave, varargin)

if length(varargin) == 1
    scale = varargin{1};
else
    scale = 1;
end

load('mat/stationList.mat'); % var: stations

resolutions = {'cru', 'med', 'fin'};

n = find(strcmp(station, stations(:,1)),1);

if isempty(n)
    fprintf('%s is not a valid station\n', station);
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

fin = [dir 'fd01.times'];

lineLength = (4+nx*2+4);
preBytes = lineLength*ny * (K-1) + lineLength*(J-1) + 4 + (I-1)*2;

fid = fopen(fin,'r');

fseek(fid,preBytes,0);
X = fread(fid, 1, 'int16');

fclose(fid);

if scale
    X = X * tmax/32766;
end