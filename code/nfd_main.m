% Main nfd script.
% Takes care of creating binary velocity models
% and calculations with the eikonal solver nfd.
%
% The script runs calculations for all accepted stations in model area
% on three different grid-sizes and for both P- and S-waves.
%
% All necessary files are stored in bin/[STAT]/[RES]/[WAVE]/
% These files are input to nfd, output from nfd and a binary matlab-file
% with descritization details
%
%
% Kristian Evers, June 2011

clear all; clc;

%% WRITE BINARY MODEL FILES

model = 'GEUS';
dir = ['bin/' model '/'];

% 3DMLD
if 1
    load('mat/V_fin_P.mat');nfd_writeBinary([dir 'vel_fin_P.mod'],V);clear V;
    load('mat/V_fin_S.mat');nfd_writeBinary([dir 'vel_fin_S.mod'],V);clear V;
end

% GEUS
if 0
    load('mat/V_GEUS_fin_P.mat');nfd_writeBinary('bin/GEUS/vel_fin_P.mod',V);clear V;
    load('mat/V_GEUS_fin_S.mat');nfd_writeBinary('bin/GEUS/vel_fin_S.mod',V);clear V;
end


%% LOOP THROUGH STATIONS

load('mat/stationList.mat'); %var stations

model = '3DPg';

N = size(stations,1);
S = stations(:,1);
R = {'cru', 'fin'};
W = {'P', 'S'};

cmdStr = '';

for i=1:N
    
    for j=1:2
        for k=1:2
            
            station = S{i};
            res = R{j};
            wave = W{k};
            dir = ['bin/' model '/' station '/' res '/' wave '/'];
            
            % if directory doesn't exist
            % -> create dir and run calculations
            if exist(dir, 'dir') ~= 7
                disp(['=========  ' dir '  ========'])
                mkdir(dir);
                
                nfd_writeVelMod(model,station, res, wave);
                nfd_setupPar(model,station, res, wave);
                if strcmp(res, 'cru')
                    continue;
                end
                [calcStr status log] = nfd_calc(model, station, res, wave);
                
                if status ~= 0
                    disp(log);
                end
                
                tmp = strtrim(log);
                
                if tmp(end) == '*'
                    disp(log)
                end
                
                % append calcStr to cmdStr
                cmdStr = strcat(cmdStr, calcStr);
            end
        end
    end
end

f1 = fopen(['bin/run_nfd_' model '.sh'], 'w');
fprintf(f1, '#!/bin/bash\n');
fprintf(f1, '%s', cmdStr);
fprintf(f1, '\ncd ../../../../\n');
fclose(f1);
system(['chmod +x bin/run_nfd_' model '.sh']);
sprintf(' !!! Run run_nfd.sh from bin/ to finish calculations !!!\n\n');


