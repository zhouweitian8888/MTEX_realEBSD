
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
setMTEXpref('zAxisDirection','inSidePlane');

%% Specify File Names

% path to files
%pname = 'E:\Master\Data\multiPara_EBSD\20210325zhouweitian\111';
pname = 'E:\Master\Data\multiPara_EBSD\新建文件夹\15-16';
% which files to be imported
fname = strcat(pname,"\15'-1.cpr");
disp(fname);
% create an EBSD variable containing the data
ebsd = EBSD.load(fname,CS,'interface','crc',...
  'convertEuler2SpatialReferenceFrame');

rot = rotation.byEuler(90*degree,90*degree,0*degree);
ebsd = rotate(ebsd,rot,'keepXY');

ipfKey = ipfColorKey(ebsd('fcc'));
ipfKey.inversePoleFigureDirection = vector3d.Z;
colors = ipfKey.orientation2color(ebsd('fcc').orientations);
plot(ebsd('fcc'),colors);



%psi = calcKernel(ebsd.orientations);
% grains reconstruction
grains = calcGrains(ebsd);

% correct for to small grains
grains = grains(grains.grainSize>5);

% compute optimal halfwidth from the meanorientations of grains
psi = calcKernel(grains('fcc').meanOrientation);

% compute the ODF with the kernel psi
odf = calcDensity(ebsd('fcc').orientations,'kernel',psi);
disp(textureindex(odf))
%h = [Miller(1,0,0,odf.CS),Miller(1,1,0,odf.CS),Miller(1,1,1,odf.CS)];


