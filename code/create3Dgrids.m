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
hc = hc/1000;    % course grid, km - one crude cell is equal to 20 fine cells
hm = hm/1000;    % medium grid, km - one medium cell is equal to 4 fine cells
hf = hf/1000;    % fine grid, km

Z  = Zmax / 1000;           % Depth to bottom of grid
Vm = Vmantle/1000;   % Fixed mantle velocity, km/s

% allocate memory
[M,N] = size(TPZ_V);
P = Z/hf;

% MAKE THIS ONE OR TWO LAYERS BIGGER IN -Z-DIRECTION
Vf = zeros(N,M,P, 'int16');

%% fill fine grid
for x=1:N
   tic;
   for y=1:M
       
       zi = [TPZ_D(y,x) EUC_UCLC(y,x) EUC_MOHO(y,x)];
       Vi = [TPZ_V(y,x) EUC_UC(y,x) EUC_LC(y,x) Vm];
       Vi = 1./Vi; % convert to slowness for better results
       zs = hf:hf:Z-hf;
       
       % USE INTERPBORDERS INSTEAD OF FINIFY
       % AND USE Vf(x,y,2:end) OR SOMETHING LIKE THAT
       Vs = finify(Vi,zi,zs); % length(Vs) == length(zs)+1
       
       Vs = 1./Vs; % convert back to velocity
       
       Vf(x,y,:) = Vs*1000;
       
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
Pm = ceil(P / c);

Vm = zeros(Nm,Mm,Pm, 'int16');

% DONT DO AVERAGES. JUST USE EVERY 4TH POINT IN Vf.
% A LOT EASIER AND IT KINDA MAKES MORE SENSE
%
% FOR X=1:4:Nm
%   FOR Y=1:4:Mm
%     FOR Z=1:4:Pm
% etc
for x=1:Nm
    tic;
    Ix = c*(x-1)+1:c*x;
    for y=1:Mm
        Iy = c*(y-1)+1:c*y;
        for z=1:Pm
            Iz = c*(z-1)+1:c*z;
            
            % fill Vm with average values
            Vm(x,y,z) = sum(sum(sum(Vf(Ix, Iy, Iz)))) / c^3;
            
        end
    end
    t = toc;
    fprintf('Processed %d of %d iterations in %f seconds\n', x, Nm, t);
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
Pc = ceil(P / c);

Vc = zeros(Nc,Mc,Pc, 'int16');

% DONT DO AVERAGES. JUST USE EVERY 10TH POINT IN Vf.
% A LOT EASIER AND IT KINDA MAKES MORE SENSE
%
% FOR X=1:10:Nm
%   FOR Y=1:10:Mm
%     FOR Z=1:10:Pm
% etc
for x=1:Nc
    tic
    Ix = c*(x-1)+1:c*x;
    for y=1:Mc
        Iy = c*(y-1)+1:c*y;
        for z=1:Pc
            Iz = c*(z-1)+1:c*z;
            
            % fill Vm with average values
            Vc(x,y,z) = sum(sum(sum(Vf(Ix, Iy, Iz)))) / c^3;
            
        end
    end
    t = toc;
    fprintf('Processed %d of %d iterations in %f seconds\n', x, Nc, t);
end

V = Vc;
save('mat/V_cru_P.mat', 'V');

% determine S-velocities
V = V./PSratio;
save('mat/V_cru_S.mat', 'V');

clear V;
