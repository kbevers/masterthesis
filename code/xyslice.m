% DESCR:        Returns a 2D-section from binary 3D file stored in
%               FORTRAN unformatted format.
%       
% INPUT:        z,      depth of xy-slice
%               nx,     x-dimension of 3D-array
%               ny,     y-dimension of 3D-array
%               nz,     z-dimension of 3D-array
%               file,   binary file to read from
%
% OUTPUT:       T,      xy-slice in 2D array of dimension [nx,ny]
%
% CALL:         T = xyslice(z, nx, ny, nz, file)

function T = xyslice(z,nx,ny,nz,file)

fid = fopen(file, 'r');

T = zeros(nx,ny);

preBytes  = (z-1) * (4+2*nx+4) * ny; 

fseek(fid,preBytes,0);
for i=1:ny
    fseek(fid,4,0);
    T(:,i) = fread(fid,nx,'int16');
    fseek(fid,4,0);
end

T = T';

fclose(fid);