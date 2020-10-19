% CALL:         q = SEISAN_get_quake(date, DB)
%
% INPUT:        date, date in format 'YYYYMMDD[hhmmss]'
%               DB, SEISAN database to search in
%
% OUTPUT:       q, struct with information about earthquake.
%
% DESCR:        Reads all relevant data about a given earthquake.

function q = SEISAN_get_quake(date, DB)

q = SEISAN_location(date, DB);
q.picks = SEISAN_get_arrivals(date, DB);
