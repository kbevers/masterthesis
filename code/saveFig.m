function str = saveFig(H, varargin)
% Automates the figure saving process.
% Figures are saved in the right location and is named after the script
% that made the figure.
% CALL: str = saveFig(H)

saveDir = '../figures/';

% get names of invoking functions. 
S = dbstack('-completenames');

if length(varargin) == 1
    str = [saveDir varargin{1}];
else
    str = [saveDir S(end).name num2str(H)];
end

%saveas(H, str, 'pdf');
print(H, '-dpdf', str);

