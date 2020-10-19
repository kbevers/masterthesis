% CALL:         loc = SEISAN_location(date)
%
% INPUT:        date, date in format 'YYYYMMDD[hhmmss]'
%               DB, SEISAN database to search in
%
% OUTPUT:       loc, struct with misc. location data from given S-file
%
% DESCR:        Get location (and error estimates) of an earthquake, 
%               as determined by ISC with 1D raytracing.
%               


function loc = SEISAN_location(date, DB)

load('mat/model.mat');
 
file = SEISAN_find_S(date, DB);

fid = fopen(file, 'r+');

type1parsed = 0;
typeEparsed = 0;
while 1
    
    line = fgetl(fid);
    if line == -1
        break;
    end
    
    lineType = line(80);
    
    if lineType == '1' && type1parsed == 0
    
        % parse type 1 line
        loc.YY      = str2double( line(2:5)   ); % year
        loc.MM      = str2double( line(7:8)   ); % month
        loc.DD      = str2double( line(9:10)  ); % day
        loc.hh      = str2double( line(12:13) ); % hour
        loc.mm      = str2double( line(14:15) ); % minute
        loc.ss      = str2double( line(17:20) ); % seconds
        loc.datenum = ...
            datenum(loc.YY, loc.MM, loc.DD, loc.hh, loc.mm, loc.ss);
        
        if line(23) == 'E'
            loc.explosion = 1; % explosion?
        else
            loc.explosion = 0;
        end
        loc.lat     = str2double( line(24:30) ); % latitude
        loc.lon     = str2double( line(31:38) ); % longitude
        
        m_proj('utm', 'zone', 32, 'lon', [lonMin lonMax], ...
            'lat', [latMin latMax], 'hemisphere', 0, 'ellipse', 'wgs84');
        [loc.utmx, loc.utmy] = m_ll2xy(loc.lon, loc.lat);
        
        loc.dep     = str2double( line(39:43) ); % depth
        loc.depfixed= line(44); % F, for fixed, S for starting value, otherwise blank
        loc.agency  = line(46:48); % Reporting agency
        loc.Nstations=str2double(line(49:51)); % number of stations used
        loc.timeRMS = str2double( line(52:55) ); % RMS of time residuals
        
        loc.mag1    = str2double( line(57:59) );
        loc.mag2    = str2double( line(65:67) );
        loc.mag3    = str2double( line(73:75) );
        
        type1parsed = 1;
        
    elseif lineType == 'E' && typeEparsed == 0
        
        % parse type E line
        loc.gap     = str2double( line(6:8)   ); % GAP
        loc.errTime = str2double( line(15:20) ); % time error [s?]
        loc.errLat  = str2double( line(25:30) ); % latitude  (y) error [km]
        loc.errLon  = str2double( line(33:38) ); % longitude (x) error [km]
        loc.errDep  = str2double( line(39:43) ); % depth     (z) error [km]
        loc.covXY   = str2double( line(44:55) ); % cov_xy [km^2]
        loc.covXZ   = str2double( line(56:67) ); % cov_xz [km^2]
        loc.covYZ   = str2double( line(68:79) ); % cov_yz [km^2]
        
        typeEparsed = 1;
    
    else
        % don't do anything
        continue;
    end
end

fclose(fid);

loc.DB = DB;
