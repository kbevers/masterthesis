function [x t] = getRay(theta, v, z, mode)
% DESCR:    Calculates rays with angle theta through given model
%
% INPUT:    theta,  ray angle
%           v,      velocity parameters. One for each layer
%           z,      layer boundaries. One more than v-parameters
%           mode,   homogeneus layers or gradient boundaries
%
% OUTPUT:   x,  x-value where the ray hits the surface
%           t,      t-values of ray-turns
%
% CALL: [x t] = getRay(theta, v, z, mode)


% calculate ray parameter
p = sin(pi/180*theta)/v(1);

[xx tt] = vz2xt(p, v, z, mode);

t = abs(tt(end))*2;
x = abs(xx(end))*2;


