%% Import Script for EBSD Data
%
% This script was automatically created by the import wizard. You should
% run the whoole script or parts of it in order to import your data. There
% is no problem in making any changes to this script.

%% Specify Crystal and Specimen Symmetries

% crystal symmetry
    CS ={...
        'notIndexed',...
        crystalSymmetry('m-3m', [3.5 3.5 3.5], 'mineral', 'Ni')};

% plotting convention
    setMTEXpref('xAxisDirection','north');
    setMTEXpref('zAxisDirection','outOfPlane');

%% Specify File Names

% path to files
pname = 'C:\Users\zhouweitian\Desktop\test\xlsx';

% which files to be imported
%fname = [pname '\slice_120l_50.0.xlsx'];
fname = ['C:\Users\zhouweitian\Desktop\test\xlsx\slice_120_55.0.xlsx'];
% this file is low

%% Import the Data

% create an EBSD variable containing the data
ebsd = EBSD.load(fname,CS,'interface','generic',...
  'ColumnNames', { 'phi1' 'Phi' 'phi2' 'Phase' 'x' 'y' 'index' 'state'}, 'Bunge', 'Radians');

[grains,ebsd.grainId,ebsd.mis2mean]=calcGrains(ebsd);
notIndexed=grains('notIndexed');

% the "not indexed grains" we want to remove
toRemove = notIndexed(notIndexed.grainSize ./ notIndexed.boundarySize<3);

% now we remove the corresponding EBSD measurements
ebsd(toRemove) = [];

%toRemove = grains(grains.grainSize<4);
%ebsd(toRemove) = [];
% and perform grain reconstruction with the reduces EBSD data set
[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd);

F = halfQuadraticFilter;
F.alpha = 0.25;

% interpolate the missing data
ebsd = smooth(ebsd,F,'fill',grains);
grains=smooth(grains,5);
%colormap jet;
%caxis([0 0.01]);
plot(grains,grains.area);
%plot(grains,grains.meanOrientation);
mtexColorMap hot
mtexColorbar;
CLim(gcm,[0,10]);
%mtexColorbar('title','area')
plot(grains,grains.area)
mtexColorbar('title','grain area')
mtexColorMap hot
CLim(gcm,[0,6000]);
hold on;
plot(grains.boundary);
%colorbar('off')
%saveas(gcf,pname_out_grainfig)
print('C:\Users\zhouweitian\Desktop\test\for_z_paper\grainsize_single\low_density_56.jpeg', '-dpng', '-r300')
%saveas(gcf,'C:\Users\zhouweitian\Desktop\grainsfig.jpg')
hold off;

cS = crystalShape.cube(ebsd('Ni').CS);

% select only grains with more then 100 pixels
grains = grains(grains.grainSize > 100);
plot(ebsd,ebsd.orientations)
% plot at the positions of the Forsterite grains the crystal shapes
hold on
plot(grains('Ni'),0.7*cS,'FaceColor',[0.3 0.5 0.3]);
plot(grains.boundary)
hold off

