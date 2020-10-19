% Determines discretization of model. Minimum and maximum coordinates
% and cell sizes are defined.
%
% TODO
% - LOAD TPZ_GRID FROM mat/ INSTEAD OF data/

load('data/TPZ_grid');
load('mat/model.mat');

% ALL UNITS IN METERS

% define cell sizes
hc =  10e3;
hm =   2e3;
hf = 0.5e3;

% min and max values
TPZxmin = min(TPZ_X(TPZ_X > 0));
TPZxmax = max(TPZ_X(TPZ_X > 0));
TPZymin = min(TPZ_Y(TPZ_Y > 0));
TPZymax = max(TPZ_Y(TPZ_Y > 0));

Lxold = TPZxmax-TPZxmin;
Lyold = TPZymax-TPZymin;


% width and height of new area
Nx = ceil((Lxold)/hc);
Ny = ceil((Lyold)/hc);
Lx = Nx * hc;
Ly = Ny * hc;

% expand area to fit crude cell sizes.
% area is expanded towards east and north.
%Xmin = TPZxmin;
%Xmax = TPZxmax + (Lx-Lxold);
a = TPZxmin:-hc:utmXmin;
Xmin = a(end);
a = Xmin:hc:utmXmax;
Xmax = a(end);

%Ymin = TPZymin;
%Ymax = TPZymax + (Ly-Lyold);
a = TPZymin:-hc:utmYmin;
Ymin = a(end);
a = Ymin:hc:utmYmax;
Ymax = a(end);

Zmin = 0;
Zmax = 60e3;

save('mat/discret.mat', 'Xmin', 'Xmax', 'Ymin', 'Ymax', 'Zmin', 'Zmax', ...
    'hc', 'hm', 'hf', 'Zpadding');