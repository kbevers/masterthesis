% CALL:         nfd_setupPar(station, res, wave)
%
% INPUT:        model, velocity model
%               station, station code
%               res, model resolution. Can be either 'cru', 'med' or 'fin'
%               wave, type of wave. Either 'P' or 'S'
%
% OUTPUT:       None
%
% DESCR:        Write parameter file f.in for nfd in the right 
%               directory. Parameter file is setup for one source only
%               (the seismic station) and the coordinates are subtracted by
%               Xmin/Ymin because nfd can't handle numbers > 10^6.
%
%               Modified from mGstat.
%
% Kristian Evers, June 2011

function nfd_setupPar(model, station, res, wave)

load('mat/stationList.mat'); % var: stations
resolutions = {'cru', 'med', 'fin'};

n = find(strcmp(station, stations(:,1))); 
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

load('mat/discret.mat');
dirStr = ['bin/' model '/' station '/' res '/' wave '/'];

load([dirStr 'disc.mat']); % xmin, xmax, ymin, ymax, zmin, zmax, nx, ny, nz, dx, minV

S = stations(n,2:4);

% setup parameters
iwrite=0; iout=1; itimes=-1;
i2d = 0; istop=0; 
nreverse=0; reverse=7;

%tmax = sqrt( (xmax-xmin)^2 + (ymax-ymin)^2 + (zmax-zmin)^2 )/(minV);

inear=0; vabove=4.0; vbelow=4.0;
nshots = size(S,1);

S = cell2mat(stations(n,2:4));

% Scale source to fit in model. Coordinates are given in KILOMETERS
S(1) = (S(1)-Xmin) / 1000;
S(2) = ymax - ( (S(2)-Ymin) / 1000 ); % High y-values correspond to low indices
S(3) = -S(3) / 1000;


% WRITE f.in
f1=fopen([dirStr 'f.in'],'w');

fprintf(f1,'  &pltpar\n');
fprintf(f1,'    iwrite=%d, iout=%d, itimes=%d,\n',iwrite,iout,itimes);
fprintf(f1,'  &end\n');

fprintf(f1,'  &axepar\n');
fprintf(f1,'  &end\n');

fprintf(f1,'  &propar\n');
fprintf(f1,'    i2d=%d, istop=%d, tmax=%.0f,', i2d, istop, tmax);
fprintf(f1,' nreverse=%d, reverse=%d, \n',nreverse, reverse);
fprintf(f1,'  &end\n');

fprintf(f1,'  &srcpar\n');
fprintf(f1,'     inear=%d, vabove=%3.1f, vbelow=%3.1f,\n',inear,vabove,vbelow);
fprintf(f1,'     isource=%d*1,\n',nshots);

sx_string=sprintf('%5.2f,',S(1));
sy_string=sprintf('%5.2f,',S(2));
sz_string=sprintf('%5.2f,',S(3));

fprintf(f1,'     xsource=%s\n',sx_string);
fprintf(f1,'     ysource=%s\n',sy_string);
fprintf(f1,'     zsource=%s\n',sz_string);
fprintf(f1,'  &end\n');

fclose(f1);
