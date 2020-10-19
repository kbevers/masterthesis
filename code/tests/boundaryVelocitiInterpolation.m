% Script to test the effect of using velocity or slowness in velocity
% interpolation around a layer boundary.
clear all; close all; addpath('..');

% Show how finify works. From Bo (with a few changes).
figA = oneColumnFig;
zi = [2,3,5]; %depths to bottoms of intervals
Xi = [1,2,3,4]; %Interval parameter, typically slowness
zs = 0.5:0.13:6; %depths to bottoms of cells
Xs = finify(Xi,zi,zs); %cell parameter
[xx,zz]=stairs([0,zi],Xi);
plot(zz,xx,'k','linewidth',2);
hold on
[xx,zz]=stairs([0,zs],Xs,'.-');
plot(zz,xx,'.-r','linewidth',1);
axis ij
xlabel('Velocity [km/s]');
ylabel('z [km]');
changeTxt(figA, 8);

delta = 0.5;

x  = -5:delta:200; % x-values in 2D-models
zf  = 0.5:0.5:50; % fine grid z-values for finify
z = -5:delta:50; % z-values in 2D-model

Z = 15.0:0.1:15.4; % Different layer boundaries to loop through
Vi = [6 8]; % Velocities in the two layers

N = length(x);
M = length(z);

% arrays to store arrival times in
Tsurf = zeros(length(Z),N);
TsurfSlow = zeros(length(Z),N);
t_refrac = zeros(length(Z),length(x(11:end)));

% zero index
I = x >= 0;

for i=1:length(Z)
    
    Zi = Z(i);
    v     = finify(Vi, Zi,zf);      % velocity
    vslow = finify(Vi.^-1, Zi,zf);  % slowness
    vslow = vslow.^-1;
    
    % Source can't be placed in (0,0) -> 2D model is expanded the left and
    % upwards
    V = zeros(M,N);
    V(1:10,:) = Vi(1);
    V(11:M,:) = v*ones(1,N);
    
    Vslow = zeros(M,N);
    Vslow(1:10,:) = Vi(1);
    Vslow(11:M,:) = vslow*ones(1,N);
    
    % eikonal solving
    T     = fast_fd_2d(x,z,V,[0 0]);
    fast_fd_clean;
    Tslow = fast_fd_2d(x,z,Vslow,[0 0]);
    fast_fd_clean;
    
    % find z == 0
    Iz = find(z == 0);
    
    % store values for plotting
    Tsurf(i,:)     = T(Iz,:);
    TsurfSlow(i,:) = Tslow(Iz,:);
    
    t_refrac(i,:) = ( (2*Zi)/Vi(1) ) * sqrt(1 - Vi(1)^2/Vi(2)^2) ...
        + x(I) / Vi(2);

end

figB = oneColumnFig;
a(1) = subplot(1,2,1);
plot(x(I), (t_refrac-Tsurf(:,I)), 'linewidth',1)
legend('15.0', '15.1', '15.2', '15.3', '15.4', 'location', 'southeast')
xlim([90 x(end)])
ylim([0.021 0.044])
title('t_{1D} - t_{2D,velocity}')
ylabel('Traveltime error [s]')
xlabel('x [km]');

a(2) = subplot(1,2,2);
plot(x(I), (t_refrac-TsurfSlow(:,I)), 'linewidth', 1)
%legend('15.0', '15.1', '15.2', '15.3', '15.4', 'location', 'southeast')
xlim([90 x(end)])
title('t_{1D} - t_{2D,slowness}')
ylabel('Traveltime error [s]')
xlabel('x [km]');
changeTxt(figB, 8);
linkaxes(a, 'xy');

saveFig(figA);
saveFig(figB);
