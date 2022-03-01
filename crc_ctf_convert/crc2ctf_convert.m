function output=crc2ctf_convert(pname_in,fname_in)
    startup_mtex
    
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
    fname = strcat(pname,'/',fname_in);
    %fname = [pname '\test.xlsx'];
    
%% Import the Data

% create an EBSD variable containing the data
ebsd = EBSD.load(fname,CS,'interface','crc',...
  'convertEuler2SpatialReferenceFrame');

rot = rotation.byEuler(90*degree,90*degree,0*degree);
ebsd = rotate(ebsd,rot,'keepXY');

file_name_out_path=strcat(pname,'/',fname_in,'.ctf');
ebsd.export(file_name_out_path);
output=file_name_out_path;
end