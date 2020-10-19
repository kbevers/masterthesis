% DESCR:            Converts x- and z-values from vz2xt, which is on half a
%                   ray, to full ray-paths.
%
% INPUT:            X,  x-output from vz2xt.
%                   Z,  z-input (model) from vz2xt.
%
% OUTPUT:           x,  x-coordinates of full ray-path.
%                   z,  z-coordinates of full ray-path.
%
% CALL:             [x,z] = xz2ray(X,Z)

function [x,z] = xz2ray(X, Z)

for j=1:length(X)-1
    I = j; k = j;
    if X(j) == X(j+1)
        break;
    end
end

x = zeros(1,2*I-1);

for j=1:2*I-1
    if j <= I
        x(j) = X(j);
    else
        k = k-1;
        x(j) = x(j-1) + (x(k+1) - x(k));
    end
end

z = [Z(1:I) fliplr(Z(1:I-1))];

