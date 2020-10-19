function T = yzslice(x,nx,ny,nz,file)

T = zeros(nz,ny);

fid = fopen(file,'r');

preBytes  = 4 + (x-1)*2;
postBytes = (nx-x)*2 + 4;

for i=1:nz
    for j=1:ny
        fseek(fid, preBytes,0);
        T(i,j) = fread(fid,1,'int16');
        fseek(fid,postBytes,0);
    end
end

fclose(fid);
