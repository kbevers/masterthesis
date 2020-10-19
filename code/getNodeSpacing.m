function h = getNodeSpacing(res)

load('mat/discret.mat');

if strcmp(res, 'fin')
    h = hf;
elseif strcmp(res, 'med')
    h = hm;
else
    h = hc;
end
