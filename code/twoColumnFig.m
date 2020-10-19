function f = twoColumnFig(varargin)

f = figure;

if length(varargin) ~= 1
    h = 15;
else
    h = varargin{1};
end

set(f, 'PaperUnits', 'centimeters');
set(f, 'PaperSize', [21 h]);
set(f, 'PaperPosition', [0 0 21 h]);