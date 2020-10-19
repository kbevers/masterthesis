close all; clear all;

figA = compareMultiLocations('SEISA', 'GEUS', 0);
figB = compareMultiLocations('ORIG_', 'GEUS', 0);
figC = compareMultiLocations('SEISA', '3DMDL', 0);
figD = compareMultiLocations('ORIG_', '3DMDL', 0);

saveFig(figA);
saveFig(figB);
saveFig(figC);
saveFig(figD);
