function [xs, ys] = ellipseCrossSection(q, ax)

load('mat/discret.mat');

% Create covariance matrix

if q.errDep ~= 0
    dim = 3;
    C = [q.errLon^2     q.covXY     q.covXZ;
              q.covXY        q.errLat^2  q.covYZ;
              q.covXZ        q.covYZ     q.errDep^2];
else
    dim = 2;
    C = [q.errLon^2     q.covXY;
         q.covXY        q.errLat^2;];
end


lx = q.errLon*1000;
ly = q.errLat*1000;
lz = q.errDep*1000;

X = linspace(q.utmx-lx*2, q.utmx+lx*2, 50);
Y = linspace(q.utmy-ly*2, q.utmy+ly*2, 50);
Z = linspace(q.dep*1000-lz*2, q.dep*1000+lz*2, 50);

if strcmp(ax, 'xy')
    %[Ys, Xs] = meshgrid(Y, X);
    [I, J] = meshgrid(Y, X);
    R = [J(:)'; I(:)'; zeros(1,length(I(:)))+q.dep*1000] ./ 1000;
end

if strcmp(ax, 'xz')
    [I, J] = meshgrid(Z, X);
    R = [J(:)'; zeros(1,length(I(:)))+q.utmy; I(:)'] ./ 1000;
    if dim == 2
        % No uncertainty ellipse in this dimension
        xs = NaN;
        ys = NaN;
        return;
    end
end

if strcmp(ax, 'yz')
    [I, J] = meshgrid(Y, Z);
    R = [zeros(1,length(I(:)))+q.utmx; I(:)'; J(:)'] ./ 1000;
    if dim == 2
        % No uncertainty ellipse in this dimension
        xs = NaN;
        ys = NaN;
        return;
    end
end

v = [q.utmx q.utmy q.dep*1000]'./1000; % center of ellipse "reference vector"

if dim == 2
    R = R(1:2,:);
    v = v(1:2);
end

% Test if each point is in or out of the ellipse
K = zeros(1,length(R)); % store values of ellipse-test here

for b = 1:length(R);
    
    K(b) = (R(:,b) - v)' * ( C \ (R(:,b) - v));
    
end

% Calculate ellipse-contour (SEISAN solution)
c = contour(J, I, reshape(K, size(I)), [1 1]);

xs = c(1,2:c(2,1)+1); ys = c(2,2:c(2,1)+1);

