% RESAMPLE RESULTS IN CRUDE RESOLUTION FROM FINE RESOLUTION

model = 'GEUS'; % change to whatever models needs to be resampled

load('mat/stationList.mat');

nx = 99; ny = 81; nz = 9;
M = zeros(nx,ny,nz);

f = @(x) (x-1)*20+1;

phase = 'PS';

tic;

for a = 1:length(stations)
    station = stations{a,1};
    
    for b = 1:2
        
        M = zeros(nx,ny,nz);
        
        for i=1:nx
            for j=1:ny
                for k=1:nz
                    
                    I = f(i);
                    J = f(j);
                    
                    if k == 1
                        K = 1;
                    elseif k == 2
                        K = 2;
                    else
                        K = f(k);
                    end
                    
                    M(i,j,k) = nfd_readScalar(I,J,K,model,station,'fin',phase(b),0);
                    
                end
            end
            fprintf('%s, %s, %d\n', station, phase(b), i);
        end
        
        fileStr = visual_binfile('res', model, station, 'cru', phase(b));
        [~, discFin] = visual_binfile('res', model, station, 'fin', phase(b));
        
        tmax = discFin.tmax;
        save(['bin/' model '/' station '/cru/' phase(b) '/disc.mat'], '-append', 'tmax');
        
        %M = M/disc.tmax * 32767;
        
        nfd_writeBinary(fileStr, M);
        
    end
end

t = toc;

t/60




