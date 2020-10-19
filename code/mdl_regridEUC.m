% Regrids EuCRUST07 data in an 2D-array, converts values to 
% UTM-coordinates and creates a finer mesh by interpolation

clear all; close all;
%addpath('..');
load 'mat/EUC.mat';
load 'mat/discret.mat'

% REGRIDDING

minX = min(EUC_X);
maxX = max(EUC_X);
minY = min(EUC_Y);
maxY = max(EUC_Y);


[Xll,Yll] = meshgrid(minX:0.25:maxX, maxY:-0.25:minY); % ll: lat/long
[M,N] = size(Xll);

AVGC = zeros(M,N);
BASE = zeros(M,N);
LC   = zeros(M,N);
MOHO = zeros(M,N);
TOPO = zeros(M,N);
UC   = zeros(M,N);
UCLC = zeros(M,N);

for i=1:length(EUC_X)
    I = find(Xll == EUC_X(i) & Yll == EUC_Y(i));
    
    AVGC(I) = EUC_AVGC(i);
    BASE(I) = EUC_BASE(i);
    LC(I)   = EUC_LC(i);
    MOHO(I) = EUC_MOHO(i);
    TOPO(I) = EUC_TOPO(i);
    UC(I)   = EUC_UC(i);
    UCLC(I) = EUC_UCLC(i);
    
end

m_proj('utm', 'zone', 32, 'lon', [minX maxX], 'lat', [minY maxY], ...
    'hemisphere', 0, 'ellipse', 'wgs84')

[X,Y] = m_ll2xy(Xll,Yll);

clear 'EUC_*';

[EUC_X, EUC_Y] = meshgrid(Xmin:500:Xmax, Ymax:-500:Ymin);

fprintf('Creating interpolation functions\n');
tic;
Favgc = TriScatteredInterp(X(:),Y(:),AVGC(:));
Fbase = TriScatteredInterp(X(:),Y(:),BASE(:));
Flc   = TriScatteredInterp(X(:),Y(:),LC(:));
Fmoho = TriScatteredInterp(X(:),Y(:),MOHO(:));
Ftopo = TriScatteredInterp(X(:),Y(:),TOPO(:));
Fuc   = TriScatteredInterp(X(:),Y(:),UC(:));
Fuclc = TriScatteredInterp(X(:),Y(:),UCLC(:));
toc

fprintf('Interpolating\n');
tic;
EUC_AVGC = Favgc(EUC_X, EUC_Y);
EUC_BASE = Fbase(EUC_X, EUC_Y);
EUC_LC   = Flc  (EUC_X, EUC_Y);
EUC_MOHO = Fmoho(EUC_X, EUC_Y);
EUC_TOPO = Ftopo(EUC_X, EUC_Y);
EUC_UC   = Fuc  (EUC_X, EUC_Y);
EUC_UCLC = Fuclc(EUC_X, EUC_Y);
toc

save('mat/EUCinterped.mat', 'EUC_*');
