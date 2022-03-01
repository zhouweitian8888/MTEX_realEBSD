function output=plotebsd_for_single_ori_plot(pname_in,fname_in,pname_out_polefig,pname_out_grainfig)
    startup_mtex 
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
    %pname = 'C:\Users\zhouweitian\Desktop';
    pname = pname_in;

% which files to be imported
    fname = strcat(pname,'\',fname_in);
    %fname = [pname '\test.xlsx'];
    output=fname
%% Import the Data

% create an EBSD variable containing the data
ebsd = EBSD.load(fname,CS,'interface','generic',...
  'ColumnNames', { 'phi1' 'Phi' 'phi2' 'Phase' 'x' 'y'}, 'Bunge', 'Radians');

rot = rotation.byEuler(90*degree,0*degree,0*degree);
ebsd = rotate(ebsd,rot,'keepXY');

%psi = calcKernel(ebsd.orientations);
% grains reconstruction
grains = calcGrains(ebsd);

% correct for to small grains
grains = grains(grains.grainSize>5);

% compute optimal halfwidth from the meanorientations of grains
psi = calcKernel(grains('Ni').meanOrientation);

% compute the ODF with the kernel psi
odf = calcDensity(ebsd('Ni').orientations,'kernel',psi);
h = [Miller(1,0,0,odf.CS),Miller(1,1,0,odf.CS),Miller(1,1,1,odf.CS)];
plotPDF(odf,h,'antipodal','silent');
%CLim(gcm,'equal');
mtexColorbar
print(pname_out_polefig, '-dpng', '-r300')
%saveas(gcf,'C:\Users\zhouweitian\Desktop\polefig.jpg')

pause(0.01)

%[grains,ebsd.grainId,ebsd.mis2mean]=calcGrains(ebsd);
%notIndexed=grains('notIndexed');
%toRemove = notIndexed(notIndexed.grainSize ./ notIndexed.boundarySize<3);
%ebsd(toRemove) = [];
%[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd);

grains=smooth(grains,5);

%plot(ebsd,ebsd.orientations);

ipfKey = ipfColorKey(ebsd('Ni'));
ipfKey.inversePoleFigureDirection = vector3d.Z;
colors = ipfKey.orientation2color(ebsd('Ni').orientations);
%plot(ebsd('Ni'),colors);

hold on;
plot(grains.boundary);
hold on
cS = crystalShape.cube(ebsd('Ni').CS);
plot(grains('Ni'),0.8*cS,'linewidth',2,'colored');
hold off

cS = crystalShape.cube(ebsd('Ni').CS);
plot(grains('Ni'),0.8*cS,'linewidth',2,'colored');
print(pname_out_grainfig, '-dpng', '-r300')
%saveas(gcf,'C:\Users\zhouweitian\Desktop\grainsfig.jpg')
hold off;

pause(1);


end
