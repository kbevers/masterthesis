%test_finify.m
%function Xs = finify(Xi,zi,zs,finifymode)
%zi defines coarse intervals and zs defines diner intervals
%Xs equals the interval values Xi when the finer interval is fully
%contained in a coarser interval.
%When a finer interval straddles a coarse interface the finer interval
%value is the weighted mean of the coarser interval values
clear; close all
% zi = [2,3,5];
% Xi = [1,2,3,4];
% zs = 0.5:0.13:3.5;
zi = [2,3,5]; %depths to bottoms of intervals
Xi = [1,2,3,4]; %Interval parameter, typically slowness
zs = 0.5:0.13:6; %depths to bottoms of cells
Xs = finify(Xi,zi,zs); %cell parameter
[xx,zz]=stairs([0,zi],Xi)
plot(zz,xx,'b','linewidth',3);
hold on
[xx,zz]=stairs([0,zs],Xs,'.-')
plot(zz,xx,'.-r','linewidth',1)
set(gca,'ydir','rev')
