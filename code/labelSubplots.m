% INPUT:    fig,    Figure handle. If no figure handle is supplied GCF will
%                   be used instead.
%
% OUTPUT:   t,      Array of text-label handles.
% 
% CALL:     t = labelsSubplots(fig, pos, color)
%
% DESCR:    Puts text-labels on alle subplots in a figure. Manipulation of
%           the labels can be done by changing settings in the handle t.
%

% Kristian Evers, december 2010

function t = labelSubplots(varargin)

initVars; % default values. get figureLabelTxtSize from here.

if nargin > 3
    error('Too many input arguments!');
elseif nargin == 1
    fig = varargin{1};
    pos = 'left';
    c = [0 0 0];
elseif nargin == 2
    fig = varargin{1};
    pos = varargin{2};
    c = [0 0 0];
elseif nargin == 3
    fig = varargin{1};
    pos = varargin{2};
    c = varargin{3};
else
    fig = gcf;
    pos = 'left';
    c = [0 0 0];
end

childs = get(fig, 'Children');

N = length(childs);
t = zeros(1,N);

labels = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'i'];

n = 0;

for i=N:-1:1
    % Don't put a label on colorbars
    if strcmp(get(childs(i), 'Tag'), 'Colorbar')
        continue;
    end
    n = n + 1;
    subplot(childs(i));
    t(n) = text(1,1, labels(n));
end

t = t(1:n);

set(t, 'FontSize', g.figureLabelTxtSize, 'FontWeight', 'Bold')
set(t, 'Color', c);
set(t, 'Units', 'normalized')

if strcmp(pos, 'left')
    set(t, 'Position', [0.03 0.92]);
else
    set(t, 'Position', [0.93 0.92]);
end
