% CALL:       str = SEISAN_find_S(date, DB)
% 
% INPUT:      date, date in format 'YYYYMMDD[hhmmss]'
%             DB, SEISAN database to search in
% 
% OUTPUT:     str, str with path to S-file in SEISAN database
% 
% DESCR:      Determines the path to the wanted SEISAN S-file.


function str = SEISAN_find_S(date, DB)

databasedir = ['../SEISAN/REA/' DB];

lenDate = length(date);
if  lenDate < 8
    error('wrong format used in input date'); 
end

% split date str 
yyyy = date(1:4);
MM   = date(5:6);
dd   = date(7:8);

if lenDate > 9
    hh = date(9:10);
end
if lenDate > 11
    mm = date(11:12);
end
if lenDate > 13
    ss = date(13:14);
end
    
path = [databasedir '/' yyyy '/' MM '/'];

files = dir([path dd '*']);

if length(files) > 1
    if exist('ss', 'var')
        file = dir([path dd '-' hh mm '-' ss '*']);
    elseif exist('mm', 'var')
        file = dir([path dd '-' hh mm '*']);
    elseif exist('hh', 'var')
        file = dir([path dd '-' hh '*']);
    else 
        file = [0 0]; % dummy variable
    end
    
    if length(file) > 1
        fprintf('  More than one file was found.\n');
        fprintf('  Expand date to include more information\n');
        return
    end
    
    file = file.name;
     
else
    file = files(1).name;
end

str = [path '/' file];
clear files; % clean up
