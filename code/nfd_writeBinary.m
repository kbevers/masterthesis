% CALL:         nfd_writeBinary(filename, M)
%
% INPUT:        filename, output file
%               M, 3D-matrix that is written to binary format
%
% OUTPUT:       None
%
% DESCR:        Creates a binary file from matrix M in a format that
%               is readable by nfd.

function nfd_writeBinary(filename, M)

[nx,ny,nz] = size(M);

fid = fopen(filename, 'w');
for k=1:nz
    for j=1:ny
        fwrite(fid,2*nx,'int32');
        fwrite(fid,M(:,j,k),'int16');
        fwrite(fid,2*nx,'int32');
    end
end
fclose(fid);