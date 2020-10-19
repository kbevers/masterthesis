% CALL:         str = nfd_calc(model, station, res, wave)
%
% INPUT:        model,      velocity model
%               station,    seismic station
%               res,        grid resolution, 'cru', 'med' or 'fin'
%               wave,       wave-type, 'P' or 'S'
%
% OUTPUT:       str,        empty if res is 'cru' or 'med'. In case
%                           of res == 'fin' it contains commands to 
%                           run from terminal. nfd can't be run from
%                           within MATLAB on the fine-grid (memory).
%                           str contains several lines and ends with
%                           a \n.
%               status,     status code from nfd-run. If -1 nfd didn't
%                           run because the chosen grid was too large.
%               log,        Output from nfd-execution.
%
% DESCR:        Performs calculations with the eikonal solver nfd.
%
% Kristian Evers, June 2011
%
% August 30 2011:
% Changed the output to something more robust

function [str, status, log] = nfd_calc(model, station, res, wave)

load('mat/discret.mat');
load('mat/stationList.mat'); % var: stations

resolutions = {'cru', 'med', 'fin'};

str = '';

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

origDir = pwd;
dir = [model '/' station '/' res '/' wave '/'];

if strcmp(res, 'fin')
    str = sprintf('\necho \\!\\!\\! RUNNING NFD ON %s/%s/%s \\!\\!\\!', ...
        station, res, wave);
    str = sprintf('%s\ndate', str);
    str = sprintf('%s\ncd %s\n', str, dir);
    str = sprintf('%snfd\n', str);
    str = sprintf('%scd ../../../../\n', str);
    status = -1;
    log = sprintf('nfd not run on fine grid (%s, %s, %s)\n', ...
        station, res, wave);
else
    cd(dir);
    [status log] = system('nfd');
    if status == 127
        fprintf('\nnfd binary doesn''t seem to be in the path\n');
        cd(origDir);
        return;
    elseif status ~= 0
        fprintf('Something went wrong during execution of nfd.\n');
        cd(origDir);
        return;
    end
    cd(origDir);
end
    
    
    
