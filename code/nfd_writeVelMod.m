% CALL:         nfd_writeVelMod(station, res, wave)
%
% INPUT:        model, velocity model
%               station,    seismic station    
%               res,        can be either 'cru', 'med' or 'fin'
%               wave,       wave-type. Either 'P' or 'S'
%
% OUTPUT:       None
%
% DESCR:        Writes for.header to model-directory and creates a symlink 
%               to the proper velocity model.
%               Coordinates are subtracted by Xmin/Ymin because nfd 
%               can't handle numbers > 10^6.
%
% Kristian Evers, June 2011

function nfd_writeVelMod(model, station, res, wave)

load('mat/discret.mat');
load('mat/model.mat');

resolutions = {'cru', 'med', 'fin'};

if sum( strcmp(res, resolutions) ) ~= 1
    fprintf('%s is not a valid resolution\n', res);
    return
end

if sum( strcmp(wave, {'P', 'S'}) ) ~= 1
    fprintf('%s is not a valid wave-type\n', wave);
    return
end

% discretization
if strcmp(res,'cru')
    h = hc;
elseif strcmp(res,'med')
    h = hm;
else
    h = hf;
end

% Scale coordinates so they fit in nfd
% These go in for.header. Distance units is in KILOMETERS
% hence the division by 1000 (UTM is in meters).
x = (Xmin:h:Xmax)-Xmin;
x = x./1000;
y = (Ymin:h:Ymax)-Ymin;
y = y./1000;
z = Zmin-Zpadding*h:h:Zmax;
z = z./1000;

xmin = min(x); xmax = max(x);
nx = length(x); dx = h / 1000;
ymin = min(y); ymax = max(y);
ny = length(y); 
zmin = min(z); zmax = max(z);
nz = length(z); 

if wave == 'P'
    tmax = 200;
else
    tmax= 300;
end

dir = sprintf('bin/%s/%s/%s/%s/',model,station,res,wave);

% save discretization in .mat file
save([dir 'disc.mat'], 'xmin', 'xmax', 'ymin', 'ymax', 'zmin', 'zmax', ...
    'nx', 'ny', 'nz', 'dx', 'tmax');

% create symlink to binary velocity structure
%source = ['/bin/' model '/vel_' res '_' wave '.mod'];
source = ['../../../vel_' res '_' wave '.mod'];
target = [dir 'vel.mod'];
cmd = sprintf('ln -s %s %s', source, target);
system(cmd);


% write for.header
headerfile = [dir 'for.header'];
f2=fopen(headerfile,'w');
headerFormat = '%10.3f%10.3f%10.3f%10.3f%10.3f%10.3f%10.3f%10d%10d%10d\n';
fprintf(f2, headerFormat, xmin,xmax,ymin,ymax,zmin,zmax,dx,nx,ny,nz);
fclose(f2);

