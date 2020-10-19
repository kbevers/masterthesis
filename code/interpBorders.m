% CALL:     vi = interpBorders(z,v,zi)
%
% INPUT:    z, original z-values
%           v, original v-values
%           zi, "interpolated" z-values
%
% OUTPUT:   vi, "interpolated" v-values

function vi = interpBorders(z,v,zi)

n = length(z);
startI = 1;

for i=1:n
    if v(i) == 0 || z(i) == 0
        continue;
    end
    [~, I] = min(abs(zi-z(i)));    
    vi(startI:I) = v(i);
    startI = I+1;
end