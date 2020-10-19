% CALL:         picks = SEISAN_get_arrivals(date, DB)
%
% INPUT:        date, date in format 'YYYYMMDD[hhmmss]'
%               DB, SEISAN database to search in
%
% OUTPUT:       picks, cell-array with arrivals information.
%
% DESCR:        Reads the picked arrivals from a given S-file.
%               All phases and misc. info is listed.
%
% TODO:
% - Read time-weigts, sigma

function picks = SEISAN_get_arrivals(date, DB)

% load predefined list of usable stations
load('mat/stationList.mat', 'stations'); 

% Find the right S-file
file = SEISAN_find_S(date, DB);

% used in datenum-determination
YY = str2double(date(1:4));
MM = str2double(date(5:6));
DD = str2double(date(7:8));

% Read S-file
n = 0;
fid = fopen(file, 'r');
while 1
    line = fgetl(fid);
    
    if line == -1
        % if EOF is reached
        break;
    end
    
    if line(80) == ' ' && sum(strcmp(strip_space(line(2:6)), stations(:,1)))
        if line(11) == 'A' || line(11) == 'I' ...
                || isempty(strip_space( line(11:14) ))
            continue;
        end
        %disp(line);
        n = n + 1;
    end
end

% allocate memory
picks = cell(n, 7); % code, phase, time, weigth, residual, travel_time, epi_dist

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% READ PICKS FROM SEISAN-FILE                                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fseek(fid, 0, -1); % rewind file
i = 0;
type1parsed = 0;
while 1 % loop through each line
    line = fgetl(fid);
    
    if line == -1
        % if EOF is reached
        break;
    end
    
    
    if line(80) == '1' && type1parsed == 0
    
        % parse type 1 line
        YY      = str2double( line(2:5)   ); % year
        MM      = str2double( line(7:8)   ); % month
        DD      = str2double( line(9:10)  ); % day
        hh      = str2double( line(12:13) ); % hour
        mm      = str2double( line(14:15) ); % minute
        ss      = str2double( line(17:20) ); % seconds
        Tepi = datenum(YY, MM, DD, hh, mm, ss);
        type1parsed = 1;
    end
    
    % use only lines containing phase information
    if ~strcmp( line(80), ' ' )
        continue;
    end
    
    station = strip_space(line(2:6));
    
    % continue if station is not accepted
    if sum( strcmp(station, stations) ) ~= 1
        continue;
    end

    % phase, strip for unwanted whitespace
    phase = strip_space( line(11:14) );
    
    % skip if informations is unwanted
    if isempty(phase) || isempty(station) || ...
            phase(1) == 'A' || phase(1) == 'I'
        continue;
    end
    
    % convert time to numerical value;
    if strcmp(line(19:20),'  ') % take care of unwanted NaN's
        hh = 0;
    else
        hh = str2double( line(19:20) );
    end
    mm = str2double( line(21:22) );
    ss = str2double( line(23:28) );
    
    time = datenum(YY, MM, DD, hh, mm, ss);
    
    weigth = str2double(line(15)); % weigth indicator
    % blank=100%, 1=75%, 2=50%, 3=25%, 4=0%
    if isnan(weigth)
        weigth = 0;
    end
    
    %if weigth == 0 && ~isnan(secondaryWeigth)
    %    weigth = secondaryWeigth;
    %end
    
    switch weigth
        case 0
            weigth = 1;
        case 1
            weigth = 0.75;
        case 2
            weigth = 0.50;
        case 3
            weigth = 0.25;
        case 4
            weigth = 0;
    end
    
    travel_time_residual = str2double(line(64:68)); % [s]
    travel_time = (time - Tepi) * (24*3600) + travel_time_residual;
    
    epicentral_distance  = str2double(line(71:75)); % [km]
    
    i = i + 1;
    picks{i,1} = station;
    picks{i,2} = phase;
    picks{i,3} = time;
    picks{i,4} = weigth;
    picks{i,5} = travel_time_residual;
    picks{i,6} = travel_time;
    picks{i,7} = epicentral_distance;
end

fclose(fid);