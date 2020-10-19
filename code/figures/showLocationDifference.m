close all; clear all;
addpath('..')

fig = twoColumnFig;

q1 = SEISAN_get_quake('20030906', 'ORIG_');
q2 = SEISAN_get_quake('20030906', 'SEISA');

m_proj('mercator', 'lon', [7 15.5], 'lat', [55.5 59]);
hold on
m_gshhs_i('color', [0.5 0.5 0.5]);
m_grid

% plot location from GEUS model
[x, y, ax, ay] = errorEllipse(q1);
m_plot(x, y, 'r', 'linewidth', 2);
m_plot(ax(:,1), ax(:,2),'k')
m_plot(ay(:,1), ay(:,2),'k')


% plot location from SEISAN model
[x, y, ax, ay] = errorEllipse(q2);
m_plot(x, y, 'b', 'linewidth', 2);
m_plot(ax(:,1), ax(:,2),'k')
m_plot(ay(:,1), ay(:,2),'k')

title('Rød: GEUS, Blå: SEISAN');

saveFig(fig);