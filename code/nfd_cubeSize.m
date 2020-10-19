% CALL:         [nx, ny, nz, d] = nfd_cubeSize(I,J,K)
%
% INPUT:        I, x-index of crude mesh
%               J, y-index of crude mesh
%               K, z-index of crude mesh
%
% OUTPUT:       nx, size in x-direction of sub-array
%               ny, size in y-direction of sub-array
%               nz, size in z-direction of sub-array
%               d, structure with indices of min/max indices in fine mesh
%               in all three directions.
%
% DESCR:        Calculates size and position of a fine mesh sub-array from
%               indices to a point in the crude mesh. The sub-array is
%               defined as a cube around the I,J,K coordinates in the crude
%               mesh. If the starting coordinates are close to the borders
%               of the array, the size of the sub-array is shrunk
%               accordingly.

function [nx, ny, nz, d] = nfd_cubeSize(I,J,K,Nx,Ny,Nz)

% load discretization binary. Station/phase is arbitrarily chosen.
[~, disc] = visual_binfile('res', '3DMDL', 'MUD', 'fin', 'P');

blockSizeX = 40;
blockSizeY = 40;
blockSizeZ = 40;

if Nx > blockSizeX
    blockSizeX = Nx;
end

if Ny > blockSizeY
    blockSizeY = Ny;
end

if Nz > blockSizeZ
    blockSizeZ = Nz;
end

% anonymous function that converts from crude to fine resolution index
f = @(x) (x-1)*20+1;

% define boundaries, if outside model-boundaries use maximum allowed value.
i1 = f(I)-blockSizeX;
if i1 < 1
    i1 = 1;
end
i2 = f(I)+blockSizeX;
if i2 > disc.nx
    i2 = disc.nx;
end
j1 = f(J)-blockSizeY;
if j1 < 1
    j1 = 1;
end
j2 = f(J)+blockSizeY;
if j2 > disc.ny
    j2 = disc.ny;
end
k1 = f(K)-blockSizeZ;
if k1 < 3
    k1 = 3;
end
k2 = f(K)+blockSizeZ;
if k2 > disc.nz
    k2 = disc.nz;
end

nx = i2-i1+1;
ny = j2-j1+1;
nz = k2-k1+1;

d.i1 = i1; d.i2 = i2; d.j1 = j1; d.j2 = j2; d.k1 = k1; d.k2 = k2;