% Script that is used to determine the boundaries of usable area in TPZ-data.
%
% Select points on the boundary with mouse. Points can be deleted by clicking twice.
% Keyboard commands:
%
% i:            zoom in
% o:            zoom out
% arrow keys:   navigation
% d:            depth-view
% v:            velocity-view
% esc:          stop
% backspace:    delete last point

close all; 
clear all;
load('mat/TPZ_grid.mat');
load('mat/I.mat');

SIZ = size(TPZ_V);
minX = 1; maxX = SIZ(2);
minY = 1; maxY = SIZ(1);

overlap = 10; % number of overlapping cells when moving zoomed area
shift = 50;

dx = [minX minX+shift];
dy = [maxY-shift maxY];

%I = zeros(SIZ);

button = 1;
zoomState = 0; % 1: zoomed in, 0: zoomed out
pickType = 'o'; % [o]uter, [i]nner
plotType = 'v'; % [v]elocity, [d]epth
figure

while button ~= 0;
    
    hold off
    if plotType == 'v'
        imagesc(TPZ_V);
    else
        imagesc(TPZ_D);
    end
    grid on;
    axis equal;
    hold on;
    plot([dx(1) dx(2) dx(2) dx(1) dx(1)], ...
        [dy(1) dy(1) dy(2) dy(2) dy(1)], '-r');
    
    [a,b] = find(I>0);
    plot(b,a, '.r', 'markersize', 12);
    %plot(bb,aa, '.m', 'markersize', 12);
    
    if pickType == 'o'
        title('Picking outer points');
    else
        title('Picking inner points');
    end
    
    if zoomState
        xlim(dx); ylim(dy);
    else
        xlim([minX maxX]); ylim([minY maxY]);
    end
    
    [x,y,button] = ginput(1);
    
    switch button
        % PICKING
        case 1
            % input from mouse
            i = round(x);
            j = round(y);
            
            if pickType == 'o'
                if I(j,i) ~= 0
                    I(j,i) = 0;                       %#ok<SAGROW>
                else
                    I(j,i) = sub2ind(SIZ,j,i);        %#ok<SAGROW>
                end
            else
                if II(j,i) ~= 0
                    II(j,i) = 0;        
                else
                    II(j,i) = sub2ind(SIZ,j,i);
                end
            end
            
            
            % NAVIGATION
        case 28
            % left arrow
            dx = dx - shift+overlap;
            if zoomState
                %save I;
            end
            
        case 29
            % right arrow
            dx = dx + shift-overlap;
            if zoomState
                %save I;
            end
            
        case 30
            % up arrow
            dy = dy  - shift+overlap;
            if zoomState
                %save I;
            end
            
        case 31
            % down arrow
            dy = dy + shift - overlap;
            if zoomState
                %save I;
            end
            
        case 105
            % zoom in, press i
            zoomState = 1;
            
        case 111
            % zoom out, press o
            zoomState = 0;
            
            % FURTHER ACTIONS
        case 27
            % escape button -> stop picking
            fprintf('Stopped picking\n');
            button = 0;
        case 8
            % backspace button -> delete previous pick
            I(j,i) = 0; %#ok<SAGROW>
            
        case 100 % d
            plotType = 'd';
        case 118 % v
            plotType = 'v';
           
        otherwise
            fprintf('Wrong button-number, %d. Try again!\n', button);
    end

end

xlim([minX maxX]);
ylim([minY maxY]);

save('mat/I.mat','I');
