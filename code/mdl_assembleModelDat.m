% Loads velocity and depth data of layers in the danish crust from text-files.

clear all; close all;

load('mat/model.mat');

% data paths
data_path = 'txt/';
EuCRUST07_path = [data_path 'EuCRUST07/'];
TPZ_path = [data_path 'TPZ/'];

% filenames of TPZ data files
TPZ_twt_file    = 'TPZ_twt_MOD.DAT';
TPZ_depth_file  = 'TPZ_depth_file_MOD.DAT';
TPZ_vel_file    = 'TPZ_ave_int_vel_MOD.DAT';

% load TPZ data files to memory
fprintf('Loading TPZ data\n');
TPZ_twt = load([TPZ_path TPZ_twt_file]);    % X, Y, TWT
TPZ_d   = load([TPZ_path TPZ_depth_file]);  % X, Y, DPETH
TPZ_v   = load([TPZ_path TPZ_vel_file]);    % X, Y, AVG INT VELOCITY

% filenames of EuCRUST07 data file (readme file answers most questions)
EuCRUST07_file = '2007gl032244-ds01_MOD.txt';

% Load EuCRUST dataset to memory
% X Y UC LC AVGCRUST TOPO BASEMENT UC/LC MOHO
fprintf('Loading EuCRUST07 data\n');   
EuCRUST07 = load([EuCRUST07_path EuCRUST07_file]);

% Only use a subset of the EuCRUST07 data (only scandinavia is of interest)
% 1 is added/subtracted to make sure the area is big enough for subsequent
% interpolation
Ieu = (EuCRUST07(:,1) >= lonMin-2 & EuCRUST07(:,1) <= lonMax+1 & ...
    EuCRUST07(:,2) >= latMin-1 & EuCRUST07(:,2) <= latMax+1);

% Find indices to common coordinates
INT = intersect(intersect(TPZ_twt(:,1:2), TPZ_d(:,1:2), 'rows'), TPZ_v(:,1:2), 'rows');

[~, Itwt] = intersect(TPZ_twt(:,1:2), INT, 'rows');
[~, Id]   = intersect(TPZ_d(:,1:2), INT, 'rows');
[~, Iv]   = intersect(TPZ_v(:,1:2), INT, 'rows');

% 
% plot(TPZ_twt(:,1), TPZ_twt(:,2), '.k');
% hold on
% plot(TPZ_d(:,1), TPZ_d(:,2), '.g');
% plot(TPZ_v(:,1), TPZ_v(:,2), '.r');


% SAVE AS BINARIES
% first rename EuCRUST07 variables
EUC_X    = EuCRUST07(Ieu,1);
EUC_Y    = EuCRUST07(Ieu,2);
EUC_UC   = EuCRUST07(Ieu,3);
EUC_LC   = EuCRUST07(Ieu,4);
EUC_AVGC = EuCRUST07(Ieu,5);
EUC_TOPO = EuCRUST07(Ieu,6);
EUC_BASE = EuCRUST07(Ieu,7);
EUC_UCLC = EuCRUST07(Ieu,8);
EUC_MOHO = EuCRUST07(Ieu,9);

clear EuCRUST07;
save('mat/EUC.mat', '-regexp', 'EUC_*');

% rename and reorder TPZ variables
TPZ_X   = TPZ_twt(Itwt,1);
TPZ_Y   = TPZ_twt(Itwt,2);
TPZ_TWT = TPZ_twt(Itwt,3);
TPZ_D   = TPZ_d(Id, 3);
TPZ_V   = TPZ_v(Iv, 3);

clear TPZ_twt TPZ_d TPZ_v;
save('mat/TPZ.mat', '-regexp', 'TPZ_*');

% further cleanup
clear Itwt Id Iv INT;
