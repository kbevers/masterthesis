% CALL:         [I, nP, nS] = find_first_arrivals(q)
%
% INPUT:        q, earthquake structure
%               useP, use P arrivals. 1 or 0.
%               useS, use S arrivals. 1 or 0.
%               exPstat, cell-array with station-codes to exclude P 
%               arrivals from.
%               exSstat, cell-array with station-codes to exclude S
%               arrivals from.
%
% OUTPUT:       I, indices to first arrivals in q.picks
%
% DESCR:        Determines which are P and S arrivals should be used in
%               location algorithm. First arrivals are found and arrivals
%               from excluded stations are removed.

function [I, nP, nS] = find_first_arrivals(q, useP, useS, exPstat, exSstat)

load('mat/stationList.mat');
Nstations = length(stations);
Itemp = zeros(2*Nstations,1); % maximum size allowed

n = 0; % counters
for i=1:length(stations)
    code = stations{i,1};
    
    % if station is not in exclusion list OR if all P-arrivals are unwanted
    if useP && ~sum(strcmp(code, exPstat))
        iP = find(strcmp(code, q.picks(:,1)) & regexpcmp(q.picks(:,2), '^P'));
        
        % find index to first P arrivals
        minPt = inf;
        for j=1:length(iP)
            Pt = cell2mat(q.picks(iP(j),3));
            if Pt < minPt && q.picks{iP(j),4} > 0
                n = n + 1;
                minPt = Pt;
                Itemp(n) = iP(j);
            end
        end
    end
    
    
    if useS && ~sum(strcmp(code, exSstat))
        iS = find(strcmp(code, q.picks(:,1)) & regexpcmp(q.picks(:,2), '^S'));
        
        % find index to first S arrivals
        minSt = inf;
        for j=1:length(iS)
            St = cell2mat(q.picks(iS(j),3));
            if St < minSt && q.picks{iS(j),4} > 0
                n = n + 1;
                minSt = St;
                Itemp(n) = iS(j);
            end
        end
    end
    
end

lastI = find(Itemp == 0, 1) - 1;
if isempty(lastI)
    I = Itemp;
else
    I = Itemp(1:lastI);
end
nP = sum(regexpcmp(q.picks(I,2), '^P'));
nS = sum(regexpcmp(q.picks(I,2), '^S'));
