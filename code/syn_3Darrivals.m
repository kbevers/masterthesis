% CALL:         q = syn_3Darrivals(S, res)
%
% INPUT:        S, source of earthquake
%               res, resolution
%
% OUTPUT:       q, earthquake data structure
%
% DESCR:        Calculates ideal travel times from a given source-point
%               to available stations

function q = syn_3Darrivals(S, res,mdl)

%mdl = '3DMDL';
load('mat/discret.mat');
load('mat/stationList.mat');

h = getNodeSpacing(res);

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
q.errLat = 2;
q.errLon = 3;
q.errDep = 0;
q.covXY = 1.3;
q.covXZ = 0;
q.covYZ = 0;
q.DB = 'syn3d';
q.timeRMS = 0;

N = length(stations);

% determine indices to source

x = round( ( (S(1) + h)-Xmin) / h);
y = (Ymax-Ymin)/h - round( ( (S(2))-Ymin) / h) + 1;
%y = round( ( (S(2) + h)-Ymin) / h);
z = round( S(3)-Zmin ) / h  + 1 + Zpadding;

q.syn = [x y z];

q.picks = cell(2*N,7);
%q.picks = cell(N,6);

for i=1:N
    
    q.picks{i,1} = stations{i,1};
    q.picks{i,2} = 'P';
    %tmap = nfd_readTimeMap(stations{i,1}, res, 'P');
    %t = tmap(x,y,Zpadding+1);
    t = nfd_readScalar(x,y,z, mdl, stations{i,1}, res, 'P');
    q.picks{i,3} = q.datenum + (t / (24*3600)); % t is converted to years
    q.picks{i,4} = 1; % weigth
    q.picks{i,5} = 0; % travel-time residual
    S2 = cell2mat(stations(i,2:4));
    q.picks{i,6} = t;
    q.picks{i,7} = sqrt( sum( (S-S2).^2 ) ) / 1000;
   
end

for i=N+1:2*N
    
    q.picks{i,1} = stations{i-N,1};
    q.picks{i,2} = 'S';
    %tmap = nfd_readTimeMap(stations{i-N,1}, res, 'S');
    %t = tmap(x,y,Zpadding+1);
    t = nfd_readScalar(x,y,z, mdl, stations{i-N,1}, res, 'S');
    q.picks{i,3} = q.datenum + (double(t) / (24*3600)); % t is converted to years
    q.picks{i,4} = 1; % weigth
    q.picks{i,5} = 0; % travel-time residual
    S2 = cell2mat(stations(i-N,2:4));
    q.picks{i,6} = t;
    q.picks{i,7} = sqrt( sum( (S-S2).^2 ) ) / 1000;

end

[~, I] = sort(cell2mat(q.picks(:,7)));
q.picks = q.picks(I,:);

