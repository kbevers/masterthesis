function M = nfd_readRawBinfile(fin,nx,ny,nz)

M = zeros(nx,ny,nz);
fid = fopen(fin,'r');
for k=1:nz
    for j=1:ny
        fread(fid,1,'int32');
        M(:,j,k) = fread(fid, nx, 'int16=>uint16');
        fread(fid,1,'int32');
    end
end
fclose(fid);