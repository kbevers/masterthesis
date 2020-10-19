close all; clear all;

figA = compareMultiLocations('SEISA', 'GEUS', 1);
figB = compareMultiLocations('ORIG_', 'GEUS', 1);
figC = compareMultiLocations('SEISA', '3DMDL', 1);
figD = compareMultiLocations('ORIG_', '3DMDL', 1);

saveFig(figA);
saveFig(figB);
saveFig(figC);
saveFig(figD);
