function [xe, ye, contourLevel, xs, ys] = determineContour(q,ori)

load('mat/discret.mat');

% Create covariance matrix
Cstart = [q.errLon^2     q.covXY     q.covXZ;
          q.covXY        q.errLat^2  q.covYZ;
          q.covXZ        q.covYZ     q.errDep^2];

if Cstart(3,3) == 0
    C = Cstart(1:2,1:2);
    if ~strcmp(ori, 'xy')
        % in case that depth has been fixed and ellipse in xz or yz
        % direction is wanted
        xe = NaN; ye = NaN; contourLevel = NaN;
        xs = NaN; ys = NaN;
        return
    end
else
    C = Cstart;
end

% discretization of plane in box
d = q.locate.d;
finI = q.locate.boxI;

if strcmp(ori, 'xy')
    % XY PLANE
    I = Ymax:-hf:Ymin;
    J = Xmin:hf:Xmax;
    [I, J] = meshgrid(I(d.j1:d.j2),J(d.i1:d.i2));
    RMSplane = q.locate.T_rms(:,:,finI(3));
elseif strcmp(ori, 'xz')
    % XZ PLANE
    I = Zmin:hf:Ymax;
    J = Xmin:hf:Xmax;
    [I, J] = meshgrid(I(d.k1:d.k2),J(d.i1:d.i2));
    RMSplane = squeeze(q.locate.T_rms(:,finI(2),:));
elseif strcmp(ori, 'yz')
    % YZ PLANE
    I = Zmin:hf:Zmax;
    J = Ymin:hf:Ymax;
    [I, J] = meshgrid(I(d.k1-2:d.k2-2),J(d.j1:d.j2));
    RMSplane = squeeze(q.locate.T_rms(finI(1),:,:));

end
% 
% % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! %
% % !!!!! REPLACE THIS SECTION WITH ellipseCrossSection() !!!!! %
% % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! %
% 
% [Ny, Nx] = size(RMSplane);
% [Ys, Xs] = meshgrid( q.utmy-Ny/2*500:500:q.utmy+Ny/2*500, ...
%     q.utmx-Nx/2*500:500:q.utmx+Nx/2*500);
% 
% % columns are vectors in the plane. Division by 1000 to have the same 
% % units as the covariancematrix
% R = [Xs(:)'; Ys(:)'; zeros(1,length(Xs(:)))+q.dep*1000] ./ 1000;
% v = [q.utmx q.utmy q.dep*1000]'./1000; % center of ellipse "reference vector"
% 
% if Cstart(3,3) == 0
%     R = R(1:2,:);
%     v = v(1:2);
% end
% 
% % Test if each point is in or out of the ellipse
% K = zeros(1,length(R)); % store values of ellipse-test here
% 
% for b = 1:length(R);
%     K(b) = (R(:,b) - v)' * ( C \ (R(:,b) - v));
% end
% 
% 
% % Calculate ellipse-contour (SEISAN solution)
% c = contours(Xs, Ys, reshape(K, size(Xs)), [1 1]);
% xs = c(1,2:c(2,1)+1); ys = c(2,2:c(2,1)+1);
% 
% % Area of SEISAN-ellipse. Reference for EIK3D
% seisanArea = polyarea(xs, ys);
% 
% % !!!!!!!!!!!!!!!!!!!!!!!!!!!! %
% % !!!! REPLACE ENDS HERE !!!!! %
% % !!!!!!!!!!!!!!!!!!!!!!!!!!!! %

[xs, ys] = ellipseCrossSection(q, ori);
seisanArea = polyarea(xs, ys);


% Determine areas of different contour-leves from the eik3d-solution-plane
Ncontours = 25;
rmsInterpValues = zeros(1,Ncontours);
areas = zeros(1,Ncontours);

maxContour = max(RMSplane);

%contourValues = linspace(0.15,maxContour, Ncontours);
contourValues = 0.25:0.05:maxContour;

c = contours(J, I, (RMSplane), contourValues);

nSkip = 0;
i = 1;
while 1
    
    RMS = c(1,1+nSkip);
    
    nCoord = c(2,nSkip + 1);
    nSkip = nCoord + nSkip + 1;
    
    x1 = c(1, nSkip-nCoord+1:nSkip);
    y1 = c(2, nSkip-nCoord+1:nSkip);
    
    dist = sqrt( (x1(1) - x1(end) ).^2 + (y1(1) - y1(end) ).^2);
    
    if dist < 1000 && length(x1) > 10
    
        areas(i) = polyarea(x1, y1);
        rmsInterpValues(i) = RMS;
        A{i,1} = x1;
        A{i,2} = y1;
        
        i = i + 1;
    else
        break;
    end
    
end


if i <= 2
   
    xe = 0;
    ye = 0;
    contourLevel = 0;
    
else
    
    interpedRMSvalue = interp1(areas(1:i-1), rmsInterpValues(1:i-1), seisanArea);
    
    if isnan(interpedRMSvalue)
        % if interpedRMSvalue is NaN it can mean to thins:
        % Either the wanted value is < min(T_rms) or > max(T_rms)
        % in that case use the smallest or largest contour,
        % whichever givest the contour-area that is closest to seisanArea
        
        [~, Imin] = min(abs(seisanArea - areas(1:i-1)));
        xe = A{Imin,1};
        ye = A{Imin,2};
        contourLevel = rmsInterpValues(Imin);
                
    else
        c = contours(J, I, (RMSplane), [interpedRMSvalue interpedRMSvalue]);
        xe = c(1,2:c(2,1));
        ye = c(2,2:c(2,1));
        contourLevel = interpedRMSvalue;
        
    end
end


