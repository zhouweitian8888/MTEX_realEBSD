function output=plotebsd_realdata(pname_in,fname_in,pname_out_polefig,pname_out_grainfig)
    startup_mtex 
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
% plotting convention
    setMTEXpref('xAxisDirection','east');
    setMTEXpref('zAxisDirection','intoPlane');

%% Specify File Names

% path to files
    %pname = 'C:\Users\zhouweitian\Desktop';
    pname = pname_in;

% which files to be imported
    fname = strcat(pname,'\',fname_in);
    %fname = [pname '\test.xlsx'];
    output=fname
%% Import the Data

% create an EBSD variable containing the data
ebsd = EBSD.load(fname,CS,'interface','crc',...
  'convertEuler2SpatialReferenceFrame');

rot = rotation.byEuler(90*degree,90*degree,0*degree);
ebsd = rotate(ebsd,rot,'keepXY');

psi = calcKernel(ebsd.orientations);
% grains reconstruction
grains = calcGrains(ebsd,'angle',15*degree);

% correct for to small grains
grains = grains(grains.grainSize>5);

% compute optimal halfwidth from the meanorientations of grains
psi = calcKernel(grains('fcc').meanOrientation);

% compute the ODF with the kernel psi
odf = calcDensity(ebsd('fcc').orientations,'kernel',psi);
h = [Miller(1,0,0,odf.CS),Miller(1,1,0,odf.CS),Miller(1,1,1,odf.CS)];
plotPDF(ebsd('fcc').orientations,h,'contourf')
mtexColorbar
%saveas(gcf,pname_out_polefig)
%saveas(gcf,'C:\Users\zhouweitian\Desktop\polefig.jpg')
print(pname_out_polefig, '-dpng', '-r300')

pause(0.01)
[grains,ebsd.grainId,ebsd.mis2mean]=calcGrains(ebsd);
notIndexed=grains('notIndexed');
plot(notIndexed,log(notIndexed.grainSize ./ notIndexed.boundarySize))
mtexColorbar

% the "not indexed grains" we want to remove
toRemove = notIndexed(notIndexed.grainSize ./ notIndexed.boundarySize<1);

% now we remove the corresponding EBSD measurements
ebsd(toRemove) = [];

toRemove = grains(grains.grainSize<4);
ebsd(toRemove) = [];
% and perform grain reconstruction with the reduces EBSD data set
[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd);

F = halfQuadraticFilter;
F.alpha = 0.25;

% interpolate the missing data
ebsd = smooth(ebsd,F,'fill');
grains=smooth(grains,5);

ipfKey = ipfColorKey(ebsd('fcc'));
ipfKey.inversePoleFigureDirection = vector3d.Z;
colors = ipfKey.orientation2color(ebsd('fcc').orientations);
plot(ebsd('fcc'),colors);
hold on;

plot(grains.boundary);
%saveas(gcf,pname_out_grainfig)
pname_out_grainfig=char(pname_out_grainfig)
pname_out_grainfig_final_z=[pname_out_grainfig(1:end-4),'_IPF_Z.JPG']
print(pname_out_grainfig_final_z, '-dpng', '-r300')
%saveas(gcf,'C:\Users\zhouweitian\Desktop\grainsfig.jpg')
hold off;

ipfKey = ipfColorKey(ebsd('fcc'));
ipfKey.inversePoleFigureDirection = vector3d.X;
colors = ipfKey.orientation2color(ebsd('fcc').orientations);
plot(ebsd('fcc'),colors);
hold on;

plot(grains.boundary);
%saveas(gcf,pname_out_grainfig)
pname_out_grainfig=char(pname_out_grainfig)
pname_out_grainfig_final_z=[pname_out_grainfig(1:end-4),'_IPF_X.JPG']
print(pname_out_grainfig_final_z, '-dpng', '-r300')
%saveas(gcf,'C:\Users\zhouweitian\Desktop\grainsfig.jpg')
hold off;




end
