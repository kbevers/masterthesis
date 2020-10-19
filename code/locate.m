% CALL:         l = locate(q, P, S, exPstat, exStat, verbose);
%
% INPUT:        q, earthquake structure.
%               P, use P arrivals. 1 or 0.
%               S, use S arrivals. 1 or 0.
%               exPstat, cell-array with station-codes to exclude P
%               arrivals from.
%               exSstat, cell-array with station-codes to exclude S
%               arrivals from.
%               verbose, print results. 1 or 0.
%
% OUTPUT:       l, structure with location details.
%
% DESCR:        Locate earthquakes using a 3D velocity model
%
% TODO:
% - write warnings when using an insufficient number of stations
% - FIND A BETTER WAY TO HANDLE DUPLICATE ENTRIES IN S-FILES (WEIGHT=4)

% IMPORTANT VARIABLES
%
% t_obs:        Arrival time determined at station
% dt:           Travel time from station to eartquake
% t_est:        Estimated event time
% T_est:        Mean estimated event time. Can be weigted.
% T_rms:        Mean event time residual
% NOT IMPLEMENTED YET:
% sigma:        Uncertainty of t_obs


function q = locate(q, useP, useS, exPstat, exSstat, verbose)

% DEFINE GLOBAL VARIABLES


load('mat/discret.mat');
load('mat/stationList.mat');
%c = load('mat/coastUTM.mat');

%===================================================================%
% SETTINGS                                                          %
%===================================================================%

res = 'cru';
model = q.setup.model;

%===================================================================%
% INITIALIZE VARIABLES                                              %
%===================================================================%

discStr = ['bin/' model '/MUD/' res '/P/disc.mat'];
load(discStr, 'nx','ny','nz');

h = getNodeSpacing(res);

%===================================================================%
% MAIN LOCATION ALGORITHM                                           %
%===================================================================%

% determine first arrivals
I = find_first_arrivals(q, useP, useS, exPstat, exSstat);
P = q.picks(I,:); % P is not P-wave, but [P]icks
N = size(P,1);
t0 = P{1,3};
if ~isnan(q.setup.fixed_depth)
    D = q.setup.fixed_depth * 1000; % convert from km to m
end

%===================================================================%
% FIND MINIMA IN CRUDE RESOLUTION
%===================================================================%

t_est = zeros(nx,ny,nz,N);
weigthSum = 0;

for i=1:N
    
    station = P{i,1};
    phase = P{i,2};
    t_obs = P{i,3};
    
    if ~isnan(q.setup.Sweigth) && phase(1) == 'S'
        weigth = P{i,4} * q.setup.Sweigth;
    else
        weigth = P{i,4};
    end
    
    dt = nfd_readTimeMap(model, station, 'cru', phase(1));
    
    t_est(:,:,:,i) = (t_obs - t0) * 24*3600 - dt;
    
    if q.setup.weigthed
        t_est(:,:,:,i) = t_est(:,:,:,i) * weigth;
        weigthSum = weigthSum + weigth;
    end
    
end

if q.setup.weigthed
    T_est = sum(t_est,4) ./ weigthSum;
else
    T_est = sum(t_est, 4) ./ N;
end


sumTrms = 0;
for i=1:N
    sumTrms = sumTrms + (t_est(:,:,:,i) - T_est).^2;
end

cruT_rms = sqrt( sumTrms / N );

% search for minimum

% Determine minimum time-residual
if ~isnan(q.setup.fixed_depth)
    % if a fixed depth is defined, find the depth first
    % and then search for minimum in that layer
    h = getNodeSpacing('cru');
    
    minCruK = ceil(D / h) + Zpadding;
    T_rms_xy = cruT_rms(:,:,minCruK);
    [minTrms, I] = min(T_rms_xy(:));
    [minCruI, minCruJ] = ind2sub(size(T_rms_xy), I);
else
    [minTrms, I] = min(cruT_rms(:));
    [minCruI, minCruJ, minCruK] = ind2sub(size(cruT_rms), I);
end


%[minTrms I] = min(cruT_rms(:));
%[minCruI, minCruJ, minCruK] = ind2sub(size(cruT_rms), I);


%===================================================================%
% FIND MINIMA IN FINE RESOLUTION
%===================================================================%

% determine how big a box to open in the fine resolution
Nx = round ( (q.errLon*1.1) / (hf/1000) ) + 1;
Ny = round ( (q.errLat*1.1) / (hf/1000) ) + 1;
Nz = round ( (q.errDep*1.1) / (hf/1000) ) + 1;

[nx,ny,nz,d] = nfd_cubeSize(minCruI,minCruJ,minCruK,Nx,Ny,Nz);

% reset variables
t_est = zeros(nx,ny,nz,N);
weigthSum = 0;

for i=1:N
    
    station = P{i,1};
    phase = P{i,2};
    t_obs = P{i,3};
    
    if ~isnan(q.setup.Sweigth) && phase(1) == 'S'
        weigth = P{i,4} * q.setup.Sweigth;
    else
        weigth = P{i,4};
    end
    
    dt = nfd_cru2finCube(minCruI, minCruJ, minCruK, Nx, Ny, Nz, model, station, phase(1));
    
    t_est(:,:,:,i) = (t_obs - t0) * 24*3600 - dt;
    
    if q.setup.weigthed
        t_est(:,:,:,i) = t_est(:,:,:,i) * weigth;
        weigthSum = weigthSum + weigth;
    end
end

if q.setup.weigthed
    T_est = sum(t_est,4) ./ weigthSum;
else
    T_est = sum(t_est, 4) ./ N;
end

sumTrms = 0;
for i=1:N
    sumTrms = sumTrms + (t_est(:,:,:,i) - T_est).^2;
end

T_rms = flipdim( sqrt( sumTrms / N ) ,2);

% Determine minimum time-residual
if ~isnan(q.setup.fixed_depth)
    % if a fixed depth is defined, find the depth first
    % and then search for minimum in that layer
    h = getNodeSpacing('fin');
    
    minFinK = (D + h) / h - d.k1 + 1 + Zpadding;
    T_rms_xy = T_rms(:,:,minFinK);
    [minResidual, I] = min(T_rms_xy(:));
    [minFinI, minFinJ] = ind2sub(size(T_rms_xy), I);
else
    [minResidual, I] = min(T_rms(:));
    [minFinI, minFinJ, minFinK] = ind2sub(size(T_rms), I);
end

minI = d.i1 + minFinI - 1;
minJ = d.j1 + minFinJ - 1;
minK = d.k1 + minFinK - 1; % d.k1 >= 3

Xrms = Xmin + (minI - 1)*hf;
Yrms = Ymax - (minJ - 1)*hf;
Zrms = Zmin + (minK - 1 - Zpadding)*hf;

T_est_min = T_est(minFinI,minFinJ,minFinK); % in seconds relative to t0
% transformation to years (datenum-format)
Tepi = (T_est_min / (24*3600)) + t0;

%===================================================================%
% LOCATION UNCERTAINTIES                                            %
%===================================================================%


% Location uncertainties is defined as minResidual+ contours. A number
% of contours through the depth in the fine-block will be calculated.

contourInterval = 2000; % [m]

Kcontours = 1:contourInterval/hf:d.k2-d.k1+1;
contourDepths = (d.k1+Kcontours+1)*hf;
contourDepths = contourDepths(contourDepths>0);

contourValue = minResidual*1.682; % contour residual 68.2% larger than minimum

Y = Ymax:-hf:Ymin;
X = Xmin:hf:Xmax;
[CY, CX] = meshgrid(Y(d.j1:d.j2),X(d.i1:d.i2));

contours = cell(length(Kcontours),1);
Ic = true(length(Kcontours),1);
for i=1:length(Kcontours)
    
    c = contourc(CY(1,:),CX(:,1),T_rms(:,:,Kcontours(i)), [contourValue contourValue]);
    
    % change contour-values to NaN. This makes it possible to plot two or
    % more minimas without connecting them. See contourc for further info
    % about the c-matrix
    iNaN = c(1,:) == contourValue;
    c(:,iNaN) = NaN;
    if isempty(c)
        Ic(i) = false;
    end
    contours{i} = c; % saved in q.locate
end

contours = contours(Ic);
contourDepths = contourDepths(Ic);

%===================================================================%
% STATION RESIDUALS                                                 %
%===================================================================%
residuals = cell(N,5);

for i=1:N
    station = P{i,1};
    pha = P{i,2};
    residuals{i,1} = station;
    residuals{i,2} = pha;
    
    k = find(strcmp(station, stations));
    dist = sqrt( ( stations{k,2} - Xrms )^2 + ...
        ( stations{k,3} - Yrms )^2 );
    residuals{i,3} = round(dist / 1000);
    
    dt = nfd_readScalar(minI, minJ, minK, model, station, 'fin', pha(1));
    phase_residual = (P{i,3} - Tepi)*24*3600;
    
    residuals{i,4} = phase_residual - dt;
    
    residuals{i,5} = (P{i,3} - Tepi) * (24*3600) + residuals{i,4};
end

% calculate traveltimes



%===================================================================%
% STORE LOCATION DETAILS                                            %
%===================================================================%

% calculate coordinates in lon/lat

m_proj('utm', 'zone', 32, 'lon', [3 20], 'lat', [52 64], ...
    'hemisphere', 0, 'ellipse', 'wgs84');

[lon, lat] = m_xy2ll(Xrms, Yrms);

% Earthquake time
dv = datevec(Tepi);
q.locate.YY      = dv(1); % year
q.locate.MM      = dv(2); % month
q.locate.DD      = dv(3); % day
q.locate.hh      = dv(4); % hour
q.locate.mm      = dv(5); % minute
q.locate.ss      = dv(6); % seconds
q.locate.P = P; % Picks-structure

q.locate.cruI = [minCruI minCruJ minCruK];
q.locate.cruMinTrms = minTrms;
q.locate.cruTrms = cruT_rms;
q.locate.cruT_rms_img = cruT_rms(:,:,minCruK);
q.locate.xCru = Xmin + (minCruI-1)*hc;
q.locate.yCru = Ymax - (minCruJ-1)*hc;

q.locate.finI = [minI minJ minK];
q.locate.boxI = [minFinI minFinJ minFinK];
q.locate.minResidual = minResidual; % time residual
q.locate.d = d;
q.locate.T_rms_img = T_rms(:,:,minFinK);
q.locate.x = Xrms;
q.locate.y = Yrms;
q.locate.z = Zrms;
q.locate.lon = lon;
q.locate.lat = lat;
q.locate.residuals = residuals;
q.locate.Tepi = Tepi;

% contours
q.locate.contourDepths = contourDepths;
q.locate.contourValue = contourValue;
q.locate.contours = contours;

q.locate.T_rms = T_rms;


% print location details

if strcmp(q.DB, 'ORIG_')
    seisanData = 'Full\t';
else
    seisanData = 'Reduced';
end

if strcmp(q.setup.model, '3DMDL')
    eikModel = '3D';
else
    eikModel = '1D';
end

str = sprintf('SEISAN data: %s EIK3D model: %s\n\n', ...
    seisanData, eikModel);

str = sprintf('%sSolutions:\tYYYY MM DD hh mm ss   \tx      y\t z\tresidual\n', str);
str = sprintf('%sSEISAN:\t\t%4.0f %02.0f %02.0f %02.0f %02.0f %05.2f\t%.0f %.0f\t %.1f\t%2.2f\n', ...
    str, q.YY, q.MM, q.DD, q.hh, q.mm, q.ss, q.utmx, q.utmy, q.dep,q.timeRMS);
str = sprintf('%sEIK3D: \t\t%4.0f %02.0f %02.0f %02.0f %02.0f %05.2f\t%.0f %.0f\t %.1f\t%2.2f\n', ...
    str, q.locate.YY, q.locate.MM, q.locate.DD, q.locate.hh, q.locate.mm, q.locate.ss, ...
    q.locate.x, q.locate.y, q.locate.z / 1000, q.locate.minResidual);


str = sprintf('%s\n\t\tSEISAN\t\tEIK3D\t\tSEISAN\t\tEIK3D\n', str);
str = sprintf('%sSTATION\tPHASE\tRESIDUAL\tRESIDUAL\t1D TRAVELTIME\t3D TRAVELTIME\n', ...
    str);

for i=1:size(q.locate.residuals,1)
    
    p1 = q.locate.P(i,:);
    p2 = q.locate.residuals(i,:);
    str = sprintf('%s%s\t%s\t%7.3f\t\t%7.3f\t\t%7.3f\t\t%7.3f\n', ...
        str, p1{1}, p1{2}, p1{5}, p2{4}, P{i,6}, residuals{i,5});
end

str = sprintf('%s\n', str);

if verbose
    fprintf(str);
end

% SAVE FILES TO DISK

path = ['locations/' q.setup.model '/' q.DB '/'];

ID = sprintf('%4.0f%02.0f%02.0f%02.0f%02.0f%02.0f', ... 
    q.YY, q.MM, q.DD, q.hh, q.mm, q.ss);

file = [path ID '.log'];
fid = fopen(file,'w+');
fprintf(fid, str);
fclose(fid);


save([path ID '.mat'], 'q');





