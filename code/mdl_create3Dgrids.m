% Constructs 3D P and S wave velocity grids from EuCRUST07 
% and TPZ data.
%

clear all;
close all;
loadData;
load('mat/model.mat');
load('mat/discret.mat');

% say something
fprintf('Minimum TPZ depth %f\n',min(TPZ_D(:)));
fprintf('Maximum TPZ depth %f\n',max(TPZ_D(:)));
fprintf('Minimum UCLC depth %f\n',min(EUC_UCLC(:)));
fprintf('Maximum UCLC depth %f\n',max(EUC_UCLC(:)));
fprintf('Minimum MOHO depth %f\n',min(EUC_MOHO(:)));
fprintf('Maximum MOHO depth %f\n',max(EUC_MOHO(:)));

% === INITIAL DEFINITIONS === %

% cell sizes ( from discret.mat/loadData )
%hc = hc2/1000;    % course grid, km - one crude cell is equal to 20 fine cells
%hm = hm/1000;    % medium grid, km - one medium cell is equal to 4 fine cells
%hf = hf/1000;    % fine grid, km

Z  = Zmax / 1000;           % Depth to bottom of grid
Vmantle = Vmantle/1000;   % Fixed mantle velocity, km/s

% allocate memory
%[M,N] = size(TPZ_V);
%P = Z/hf;

M = length(Ymin:hf:Ymax);
N = length(Xmin:hf:Xmax);
P = length(Zmin:hf:Zmax) + Zpadding;

% MAKE THIS ONE OR TWO LAYERS BIGGER IN -Z-DIRECTION
Vf = zeros(N,M,P, 'int16');

%% fill fine grid
for x=1:N
   tic;
   for y=1:M
       
       h = hf / 1000;
       
       z = [TPZ_D(y,x) EUC_UCLC(y,x) EUC_MOHO(y,x) Z];
       v = [TPZ_V(y,x) EUC_UC(y,x) EUC_LC(y,x) Vmantle];
       %Vi = 1./Vi; % convert to slowness for better results
       
       zi = -Zpadding*h:h:Z;
       
       vi = interpBorders(z,v,zi);
       
       %Vs = 1./Vs; % convert back to velocity
       
       Vf(x,y,:) = vi*1000;
       
   end
   t = toc;
   fprintf('Processed %d of %d iterations in %f seconds\n', x, N, t);
end

V = Vf;

save('mat/V_fin_P.mat', 'V');

% determine S-velocities
V = V./PSratio;
save('mat/V_fin_S.mat', 'V');

clear V;

%% fill medium grid

c = hm/hf;

Mm = ceil(M / c);
Nm = ceil(N / c);
Pm = ceil(P / c) + Zpadding;

Vm = zeros(Nm,Mm,Pm, 'int16');

% DONT DO AVERAGES. JUST USE EVERY 4TH POINT IN Vf.
% A LOT EASIER AND IT KINDA MAKES MORE SENSE
%
% FOR X=1:4:Nm
%   FOR Y=1:4:Mm
%     FOR Z=1:4:Pm
% etc
i = 0;
for x=1:hm/hf:N
    tic;
    i = i + 1;
    j = 0;
    for y=1:hm/hf:M
        j = j+1;
        h = hm / 1000;
        
        z = [TPZ_D(y,x) EUC_UCLC(y,x) EUC_MOHO(y,x) Z];
        v = [TPZ_V(y,x) EUC_UC(y,x) EUC_LC(y,x) Vmantle];
        zi = -Zpadding*h:h:Z;
        vi = interpBorders(z,v,zi);
        
        Vm(i,j,:) = vi*1000;
        
    end
    t = toc;
    fprintf('Processed %d of %d iterations in %f seconds\n', x, N, t);
end

V = Vm;
save('mat/V_med_P.mat', 'V');

% determine S-velocities
V = V./PSratio;
save('mat/V_med_S.mat', 'V');

clear V;

%% fill crude grid

c = hc/hf;

Mc = ceil(M / c);
Nc = ceil(N / c);
Pc = ceil(P / c) + Zpadding;

Vc = zeros(Nc,Mc,Pc, 'int16');

% DONT DO AVERAGES. JUST USE EVERY 10TH POINT IN Vf.
% A LOT EASIER AND IT KINDA MAKES MORE SENSE
%
% FOR X=1:10:Nm
%   FOR Y=1:10:Mm
%     FOR Z=1:10:Pm
% etc
i = 0;
for x=1:hc/hf:N
    tic;
    i = i + 1;
    j = 0;
    for y=1:hc/hf:M
        j = j+1;
        h = hc / 1000;
        
        z = [TPZ_D(y,x) EUC_UCLC(y,x) EUC_MOHO(y,x) Z];
        v = [TPZ_V(y,x) EUC_UC(y,x) EUC_LC(y,x) Vmantle];
        zi = -Zpadding*h:h:Z;
        vi = interpBorders(z,v,zi);
        
        Vc(i,j,:) = vi*1000;
        
    end
    t = toc;
    fprintf('Processed %d of %d iterations in %f seconds\n', x, N, t);
end

V = Vc;
save('mat/V_cru_P.mat', 'V');

% determine S-velocities
V = V./PSratio;
save('mat/V_cru_S.mat', 'V');

clear V;
