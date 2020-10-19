% CALL:         [cube,i,j,k] = nfd_cru2finCube(I, J, K, station, phase)
%
% INPUT:        I, x-index to crude minumum
%               J, y-index to crude minumum
%               K, z-index to crude minumum
%               model, velocity model
%               station, seismic station
%               phase, P or S
%
% OUTPUT:       cube, 3D array with traveltimes
%               i, first x-index
%               j, first y-index
%               k, first z-index
%
% DESCR:        Returns a subsection of traveltimes in fine resolution.
%               The traveltime subsection is given as a cube around the
%               (I,J,K) crude coordinate. If the centerpoint is places
%               close to the edge of the model area, the returned cube is
%               reduced in size (and is strictly not a cube anymore).
%               Indices to corners of the cube can be calculated in 
%               combination with SIZE().

function [cube,i1,j1,k1] = nfd_cru2finCube(I, J, K, Nx, Ny, Nz, model, station, phase)

res = 'fin';
% Open bin-file
[binfile, disc] = visual_binfile('res', model, station, res, phase);

NI = disc.nx;
NJ = disc.ny;

[nx, ny, nz, d] = nfd_cubeSize(I,J,K, Nx, Ny, Nz);

i1 = d.i1; i2 = d.i2; j1 = d.j1; j2 = d.j2; k1 = d.k1; k2 = d.k2;

% allocate some space in memory
cube = zeros(nx, ny, nz);

%===================================================================%
% READ CUBE FROM BINARY FILE
%===================================================================%

% calcute preliminary offset
lineLength = (4+NI*2+4);
preBytes = lineLength*NJ * (k1-1) + lineLength*(j1-1) + 4 + (i1-1)*2;
ySkipBytes = (NI-i2)*2+4+4+(i1-1)*2;
zSkipBytes = (NJ-j2)*lineLength+(j1-1)*lineLength;

fid = fopen(binfile, 'r+');

% fseek and then read first line
%NI,NJ,preBytes;
fseek(fid, preBytes, 0);
N = i2-i1+1;

for z=1:k2-k1+1 % loop through the z-direction
    for y=j2-j1+1:-1:1 % loop through the y-direction
        temp = fread(fid, N, 'int16');
        cube(:,y,z) = temp;
        fseek(fid, ySkipBytes, 0);
    end
    fseek(fid, zSkipBytes, 0);
end

fclose(fid);

cube = cube .* disc.tmax/32766;

% make sure that the indices  work in the expected way
%cube = flipdim(cube,2);


