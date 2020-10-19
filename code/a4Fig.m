function f = a4Fig(varargin)

f = figure;

set(f, 'PaperType', 'A4');

if nargin > 0
    orient = varargin{1};
else
    orient = 'p';
end

if orient == 'l'
    set(f,'PaperOrientation','landscape');
    set(f,'PaperUnits','normalized');
    set(f,'PaperPosition', [0 0 1 1]);
else
    set(f, 'PaperUnits', 'centimeters');
    set(f, 'PaperSize', [21 29]);
    set(f, 'PaperPosition', [0 0 21 29]);
end