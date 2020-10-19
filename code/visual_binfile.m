% CALL:         [fileStr, disc] = visual_binfile(view, model, station, res, wave)
%
% INPUT:        view, 'res' or 'mod'
%               model, velocity model
%               station, string with station code
%               res, 'cru', 'med' or 'fin'
%               wave, 'P' or 'S'
%
% OUTPUT:       fileStr, string with location of bin-file
%               disc, struct with discretization data
%
% DESCR:        Returns path to bin-file and discretization of model

function [fileStr, disc] = visual_binfile(view, model, station, res, wave)


dir = ['bin/' model '/' station '/' res '/' wave '/'];
disc = load([dir 'disc.mat']);

if strcmp(view, 'mod')
    fileStr = [dir 'vel.mod'];
else
    fileStr = [dir 'fd01.times'];
end

end