
%% Import Script for EBSD Data
%
% This script was automatically created by the import wizard. You should
% run the whoole script or parts of it in order to import your data. There
% is no problem in making any changes to this script.

%% Specify Crystal and Specimen Symmetries

% crystal symmetry
    CS = {... 
  'notIndexed',...
  crystalSymmetry('m-3m', [3.7 3.7 3.7], 'mineral', 'fcc', 'color', [0.56 0.74 0.56]),...
  crystalSymmetry('m-3m', [3.7 3.7 3.7], 'mineral', 'fcc', 'color', [0.56 0.74 0.56]),...
  crystalSymmetry('m-3m', [3.7 3.7 3.7], 'mineral', 'fcc', 'color', [0.56 0.74 0.56]),...
  crystalSymmetry('m-3m', [3.7 3.7 3.7], 'mineral', 'fcc', 'color', [0.56 0.74 0.56])};


%% Specify File Names
% plotting convention
setMTEXpref('xAxisDirection','west');
setMTEXpref('zAxisDirection','outOfPlane');

%% Specify File Names

% path to files
pname = 'E:\Master\Data\multiPara_EBSD\20210325zhouweitian\111';

% which files to be imported
fname = strcat(pname,"\项目 1 1' 区 1 1'-1.cpr");
disp(fname);
% create an EBSD variable containing the data
ebsd = EBSD.load(fname,CS,'interface','crc',...
  'convertEuler2SpatialReferenceFrame');

rot = rotation.byEuler(9*degree,0*degree,0*degree);
ebsd = rotate(ebsd,rot,'keepXY');

psi = calcKernel(ebsd.orientations);
% grains reconstruction
grains = calcGrains(ebsd);

% correct for to small grains
grains = grains(grains.grainSize>5);

% compute optimal halfwidth from the meanorientations of grains
psi = calcKernel(grains('fcc').meanOrientation);

% compute the ODF with the kernel psi
odf = calcDensity(ebsd('fcc').orientations,'kernel',psi);
h = [Miller(1,0,0,odf.CS),Miller(1,1,0,odf.CS),Miller(1,1,1,odf.CS)];
plotPDF(ebsd('fcc').orientations,h,'contourf')

%saveas(gcf,pname_out_polefig)
%saveas(gcf,'C:\Users\zhouweitian\Desktop\polefig.jpg')
%print(filefolderpath,' '-dpng', '-r300')
print('-clipboard','-dbitmap',"-r600");
pause
[grains,ebsd.grainId,ebsd.mis2mean]=calcGrains(ebsd);
notIndexed=grains('notIndexed');
plot(notIndexed,log(notIndexed.grainSize ./ notIndexed.boundarySize))
mtexColorbar

% the "not indexed grains" we want to remove
toRemove = notIndexed(notIndexed.grainSize ./ notIndexed.boundarySize<3);

% now we remove the corresponding EBSD measurements
ebsd(toRemove) = [];

toRemove = grains(grains.grainSize<4);
ebsd(toRemove) = [];
% and perform grain reconstruction with the reduces EBSD data set
[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd);

F = halfQuadraticFilter;
F.alpha = 0.25;

% interpolate the missing data
ebsd = smooth(ebsd,F,'fill',grains);
grains=smooth(grains,5);
plot(ebsd,ebsd.orientations);
hold on;
plot(grains.boundary);
%saveas(gcf,pname_out_grainfig)
%print(pname_out_grainfig, '-dpng', '-r300')
%saveas(gcf,'C:\Users\zhouweitian\Desktop\grainsfig.jpg')
hold off;

