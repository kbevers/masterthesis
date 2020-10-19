function T = xzslice(y,nx,ny,nz,file)

T = zeros(nz,nx);

fid = fopen(file,'r');

xbytes = 2*4 + nx*2;


for k=1:nz
        fseek(fid, xbytes*(y-1) + 4, 0);
        T(k,:) = fread(fid,nx,'int16');
        fseek(fid, 4 + xbytes*(ny-y),0);
end

fclose(fid);

%tmax = sqrt( (xmax-xmin)^2 + (ymax-ymin)^2 + (zmax-zmin)^2 )/(minV/1000);

%T = double(T) .* double(tmax)/32767; % (2^15-1)