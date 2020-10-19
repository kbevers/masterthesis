% Constructs 3D-grids from EuCRUST07 and TPZ data.
%
% TODO:
% - Include grids with S-wave velocities. Possibly just a P/S-factor
%   of 1.73 (as in GEUS' model)

clear all;
close all;
addpath('..');
loadData;
load('../mat/model.mat');

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

Z  = 60;             % Depth to bottom of grid
Vm = Vmantle/1000;   % Fixed mantle velocity, km/s


% allocate memory
[M,N] = size(TPZ_V);
P = Z/hf;

Vf = zeros(N,M,P, 'int16');

%% fill fine grid
for x=1:N
   tic;
   for y=1:M
       
       zi = [TPZ_D(y,x) EUC_UCLC(y,x) EUC_MOHO(y,x)];
       Vi = [TPZ_V(y,x) EUC_UC(y,x) EUC_LC(y,x) Vm];
       Vi = 1./Vi; % convert to slowness for better results
       zs = hf:hf:Z-hf;
       
       Vs = finify(Vi,zi,zs);
       
       Vs = 1./Vs; % convert back to velocity
       
       Vf(x,y,:) = Vs*1000;
       
   end
   t = toc;
   fprintf('Processed %d of %d iterations in %f seconds\n', x, N, t);
end

save('Vf.mat', 'Vf');

%% fill medium grid

c = hm/hf;

Mm = M / c;
Nm = N / c;
Pm = P / c;

Vm = zeros(Nm,Mm,Pm, 'int16');


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

save('Vm.mat', 'Vm');

%% fill crude grid

c = hc/hf;

Mc = M / c;
Nc = N / c;
Pc = P / c;

Vc = zeros(Nc,Mc,Pc, 'int16');

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

save('Vc.mat', 'Vc');
