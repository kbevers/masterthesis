% CALL:             [x, y, ax, ay] = errorEllipse(q, latlon)
%
% INPUT:            q, earthquake structure
%                   latlon, coordinates in degrees or meters. 1 for degrees
%                   0 for meters
%
% OUTPUT:           x, x-coordinates for ellipse
%                   y, y-coordinates for ellipse
%                   ax, x-coordinates for principal axis
%                   ay, y-coordinates for principal axis
%                   
% DESCR:            Calculates error ellipse with principal axes from
%                   standard deviation and covariances in SEISAN-files.
%                   UTM example:
%
%                   [x, y, ax, ay] = errorEllipse(q,1);
%                   m_plot(x, y, 'r');
%                   m_plot(ax(:,1), ax(:,2),'k')
%                   m_plot(ay(:,1), ay(:,2),'k')


function [x, y, ax, ay] = errorEllipse(q, latlon)


% assemble covariance matrix
C = [q.errLon^2 q.covXY;
     q.covXY  q.errLat^2];


% calculate principal axes of error ellipse
[Q,D] = eig(C); % Q: eigenvectors, D: eigenvalues

% scale principal axes with standard deviations
W = Q*D.^0.5;

% calculate ellipse from principal axis
t = linspace(0,2*pi,100);
x = W(1,1) .* cos(t) + W(1,2) .* sin(t);
y = W(2,1) .* cos(t) + W(2,2) .* sin(t);

if latlon
    % conversion scalars
    xtolon = (111.2*cosd(q.lat));
    ytolat = 111.2;
end

% conversion from km to degrees
if latlon
    x = x ./ xtolon + q.lon;
    y = y ./ ytolat + q.lat;
else
    x = x * 1000 + q.utmx;
    y = y * 1000 + q.utmy;
end
    
% create principal axes in both directions
if latlon
    xa1 = [-W(1,1)./xtolon W(1,1)./xtolon]+q.lon;
    xa2 = [-W(2,1)./ytolat W(2,1)./ytolat]+q.lat;
    ya1 = [-W(1,2)./xtolon W(1,2)./xtolon]+q.lon;
    ya2 = [-W(2,2)./ytolat W(2,2)./ytolat]+q.lat;
else
    xa1 = [-W(1,1) W(1,1)]*1000+q.utmx;
    xa2 = [-W(2,1) W(2,1)]*1000+q.utmy;
    ya1 = [-W(1,2) W(1,2)]*1000+q.utmx;
    ya2 = [-W(2,2) W(2,2)]*1000+q.utmy;
end

ax = [xa1' xa2'];
ay = [ya1' ya2'];
