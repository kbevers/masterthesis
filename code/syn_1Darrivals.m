% CALL:         q = syn_1Darrivals(S, R, z, v)
%
% INPUT:        S, 3 x 1 array consisting of x-, y- and z-
%                 coordinates to seismic source
%               R, n x 4 cell-array consisting of station code and 
%                 x-, y- and z-coordinates to recievers.
%               v, velocities in all layers. In km/s
%               z, depth to all layer-boundaries. In km
%
% OUTPUT:       q, structure with earthquake information.
%
% DESCR:        Calculates synthetic earthquake data using 1D ray-
%               tracing.

% q = 
% 
%           YY: 2008
%           MM: 12
%           DD: 16
%           hh: 5
%           mm: 20
%           ss: 2.9000
%      datenum: 7.3376e+05
%          lat: 55.6830
%          lon: 13.4440
%         utmx: 7.7932e+05
%         utmy: 6.1798e+06
%          dep: 9
%      timeRMS: 3.4000
%         mag1: 4.9000
%         mag2: 4.4000
%         mag3: 4.3000
%          gap: 87
%      errTime: 9.6100
%       errLat: 7.4000
%       errLon: 15.9000
%       errDep: 0
%        covXY: 42.3800
%        covXZ: 0
%        covYZ: 0
% 
% q.arrivals(1) = 
% 
%     code: 'MUD'
%       P1: 7.3376e+05
%       S1: 0
%      pP1: 'P'
%      pS1: ''
%        P: 7.3376e+05
%        S: []
%       Pg: []
%       Pn: []
%       Sn: []
%       Lg: []


function q = syn_1Darrivals(S, R, z, v)

q.YY = 2000;
q.MM = 01;
q.DD = 01;
q.hh = 00;
q.mm = 00;
q.ss = 00;
q.datenum = datenum(q.YY, q.MM, q.DD, q.hh, q.mm, q.ss);
q.utmx = S(1);
q.utmy = S(2);
q.dep =  S(3);

rx = cell2mat(R(:,2));
ry = cell2mat(R(:,3));

N = length(R);

for i=1:N
    % settings for g_homog
    a.Rx = sqrt( (S(1)-rx(i))^2 + (S(2)-ry(i))^2 ) / 1000; % distance from source to receiver
    a.mode = 'homog';
    
    % construct model-vector
    m = [z'; v'];
    
    % calculate different wave arrival times
    [d ext] = g_homog(m,a);
    
    % first arrival. time calculated for receiver at z=0
    [t tI] = min(d);
    
    q.arrivals(i).code = R{i,1};
    q.arrivals(i).P1 = q.datenum + (t/(24*3600)); %origin time + travel time
    q.arrivals(i).S1 = 0;

end












