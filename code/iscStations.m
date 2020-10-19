%
% Generates a list of available seismic stations in model area.
% All stations are currently active.
%

clear all; close all;
load('mat/model.mat');
c = load('mat/coastUTM.mat');

fin = 'txt/stn-list.txt';
fid = fopen(fin, 'r');

str = '';
n = 0;

S{1,1} = 's';

% Read station file and save in S-struct

while 1
    
    line = fgetl(fid);
    
    if line == -1
        break;
    end
    
    if line(1) ~= ' '
        n = n + 1;
        str = line;
        if line(end) == '/'
            doubleLine = 1;
            
            while doubleLine    
                line = fgetl(fid);
                
                if line(end) ~= '/'
                    doubleLine = 0;
                end
                
                str = strcat(str, line);
            end
                
        end
        S{n} = str;
    end
    
end

fclose(fid);


N = length(S);

dmsLAT = zeros(N,4);
dmsLON = zeros(N,4);

s = regexp(S, '\/', 'split');

h = zeros(N,1);
station = zeros(N,5);
station = char(station);

active = ones(N,1);

% parse and reorganize info from station file

for i=1:N
    
    % save station codes
    temp = cell2mat(s{i}(1));
    nTemp = length(temp);
    station(i,1:nTemp) = temp;
    
    % active or not?
    if length(s{i}) > 7
        act = cell2mat(s{i}(8));
        if act(end) ~= '-'
            active(i) = 0;
        end
    end
    
    % deg, min, sec latitude
    d = regexp(s{i}(5), ':', 'split');
    
    dmsLAT(i,1) = str2double(d{1}(1));
    dmsLAT(i,2) = str2double(d{1}(2));
    ss = cell2mat(d{1}(3));
    dmsLAT(i,3) = str2double(ss(1:end-1));
    
    if ss(end) == 'S'
        dmsLAT(i,4) = -1;
    else
        dmsLAT(i,4) = 1;
    end
    
    % deg, min, sec longitude
    d = regexp(s{i}(6), ':', 'split');
    
    dmsLON(i,1) = str2double(d{1}(1));
    dmsLON(i,2) = str2double(d{1}(2));
    ss = cell2mat(d{1}(3));
    dmsLON(i,3) = str2double(ss(1:end-1));
    
    if ss(end) == 'W'
        dmsLON(i,4) = -1;
    else
        dmsLON(i,4) = 1;
    end
    
    if length(s{i}) > 6
        h(i) = str2double(s{i}(7));
    end
    
end

% convert to decimal-degrees
LAT = dms2degrees(dmsLAT(:,1:3));
LON = dms2degrees(dmsLON(:,1:3));

% move stations to right quadrant
iS = find(dmsLAT(:,4) == -1);
iW = find(dmsLON(:,4) == -1);
LAT(iS) = -LAT(iS);
LON(iW) = -LON(iW);

% find stations in model area
I = find(LON > lonMin & LON < lonMax & LAT > latMin & LAT < latMax & active == 1);


% Convert to UTM coordinates
m_proj('utm', 'zone', 32, 'lon', [lonMin lonMax], ...
    'lat', [latMin latMax], 'hemisphere', 0, 'ell', 'wgs84');


% variables to save for use in other scripts
[X, Y] = m_ll2xy(LON(I), LAT(I));
H = h(I);
code = cellstr(station(I,:));

save('mat/iscStations.mat', 'X', 'Y', 'H', 'code');

% plot
plot(c.X, c.Y, '-', 'color', [0.5 0.5 0.5]);
hold on
plot(X, Y, 'r^', 'linewidth', 1, 'markersize', 6);
text(X,Y, station(I,:));
