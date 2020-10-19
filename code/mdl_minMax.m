clear all;
close all;
clc;

load('mat/TPZ.mat');
load('mat/EUCinterped.mat');
c = load('mat/coastUTM.mat');
load('mat/I.mat');

[TPZ_V_min TPZ_V_min_I] = min(TPZ_V);
[TPZ_V_max TPZ_V_max_I] = max(TPZ_V);

figure
title('x: min, o: max. Gul: TPZ_V, Grøn: TPZ_D, Blå: EUC_UC, Magenta: EUC_UCLC, Rød: EUC_LC, Cyan: EUC_MOHO')

hold on
plot(TPZ_X, TPZ_Y, 'k.');
plot(c.X, c.Y, '-', 'color', [0.5 0.5 0.5]);

plot(TPZ_X(TPZ_V_min_I),TPZ_Y(TPZ_V_min_I),'yx', 'markersize', 10, 'linewidth', 2);
plot(TPZ_X(TPZ_V_max_I),TPZ_Y(TPZ_V_max_I),'yo', 'markersize', 10, 'linewidth', 2);

disp('TPZ_V')
disp(TPZ_V_min/1000)
disp(TPZ_V_max/1000)


[TPZ_D_min TPZ_D_min_I] = min(-TPZ_D);
[TPZ_D_max TPZ_D_max_I] = max(-TPZ_D);
plot(TPZ_X(TPZ_D_min_I),TPZ_Y(TPZ_D_min_I),'gx', 'markersize', 10, 'linewidth', 2);
plot(TPZ_X(TPZ_D_max_I),TPZ_Y(TPZ_D_max_I),'go', 'markersize', 10, 'linewidth', 2);


disp('TPZ_D')
disp(min(-TPZ_D(:)/1000))
disp(max(-TPZ_D(:)/1000))

[EUC_UC_min EUC_UC_min_I] = min(EUC_UC(:));
[EUC_UC_max EUC_UC_max_I] = max(EUC_UC(:));
plot(EUC_X(EUC_UC_min_I),EUC_Y(EUC_UC_min_I),'bx', 'markersize', 10, 'linewidth', 2);
plot(EUC_X(EUC_UC_max_I),EUC_Y(EUC_UC_max_I),'bo', 'markersize', 10, 'linewidth', 2);


disp('EUC_UC');
disp(EUC_UC_min)
disp(EUC_UC_max)



[EUC_UCLC_min EUC_UCLC_min_I] = min(EUC_UCLC(:));
[EUC_UCLC_max EUC_UCLC_max_I] = max(EUC_UCLC(:));
plot(EUC_X(EUC_UCLC_min_I),EUC_Y(EUC_UCLC_min_I),'mx', 'markersize', 10, 'linewidth', 2);
plot(EUC_X(EUC_UCLC_max_I),EUC_Y(EUC_UCLC_max_I),'mo', 'markersize', 10, 'linewidth', 2);


disp('EUC_UCLC');
disp(EUC_UCLC_min)
disp(EUC_UCLC_max)


[EUC_LC_min EUC_LC_min_I] = min(EUC_LC(:));
[EUC_LC_max EUC_LC_max_I] = max(EUC_LC(:));
plot(EUC_X(EUC_LC_min_I),EUC_Y(EUC_LC_min_I),'rx', 'markersize', 10, 'linewidth', 2);
plot(EUC_X(EUC_LC_max_I),EUC_Y(EUC_LC_max_I),'ro', 'markersize', 10, 'linewidth', 2);


disp('EUC_LC');
disp(EUC_LC_min)
disp(EUC_LC_max)

[EUC_MOHO_min EUC_MOHO_min_I] = min(EUC_MOHO(:));
[EUC_MOHO_max EUC_MOHO_max_I] = max(EUC_MOHO(:));
plot(EUC_X(EUC_MOHO_min_I),EUC_Y(EUC_MOHO_min_I),'cx', 'markersize', 10, 'linewidth', 2);
plot(EUC_X(EUC_MOHO_max_I),EUC_Y(EUC_MOHO_max_I),'co', 'markersize', 10, 'linewidth', 2);


disp('EUC_MOHO');
disp(EUC_MOHO_min)
disp(EUC_MOHO_max)