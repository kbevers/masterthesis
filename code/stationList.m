% Creates a list of all usable stations in the model area. Reads data
% from iscStations.mat

clear all;

load('mat/iscStations.mat');

stationCodes = {
            'MUD';
            'COP';
            'BSD';
            'HFS';
            'KONO';
            'SNART';
};

N = length(stationCodes);
        
stations = cell(N,4);
        
for i=1:N
    stations{i,1} = stationCodes{i};
    
    I = find(strcmp(stationCodes{i}, code));
    stations{i,2} = X(I);
    stations{i,3} = Y(I);
    stations{i,4} = H(I);
    
end

save('mat/stationList', 'stations');
