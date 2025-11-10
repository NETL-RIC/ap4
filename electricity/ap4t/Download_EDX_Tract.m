%% Read the resource IDs and resource names from CSV

% The KEY VARIABLES
% api_key = YOUR_EDX_API_KEY
% info_dir = YOUR_DIRECTORY % location of git files..
% file_id = fopen([info_dir, 'info_matrix.csv'], "r");

% NOTE: api_key is defined in AP4 Control Script as empty string
% If the EDX files exist, this step can be safely skipped.
if !(exist("api_key", "var")) || (isempty(strtrim(api_key)))
  api_key = input("Enter your API key: ", "s");
end
disp(["API Key: ", api_key]);


%% INPUTS 1 - AP4_tract_inputs

% Assume relative path to AP4_Tract_Inputs w.r.t. Download_EDX_Tract.m
info_dir1 = 'AP4_Tract_Inputs/';
file_id1 = fopen([info_dir1, 'ap4_tract_inputs.csv'], "r");

% Read the header row (and discard it)
header = fgetl(file_id1);

% Read data rows: resource_IDs --> data1{i,1}; resource_names-->data1{i,2}
data1 = {};
while (!feof(file_id1))
  line1 = fgetl(file_id1);
  if (ischar(line1))
    row1 = strsplit(line1, ",");
    data1 = [data1; row1];
  end
end
fclose(file_id1); % close open file

% Construct the CSVs
% Runs the function 'download_function'
% - sequence of inputs:(resource_id, api_key, local_filename, info_dir)
for i = 1:rows(data1)
   download_function(data1{i,1}, api_key, data1{i,2}, info_dir1);
end

%% INPUTS 2 - IDW

% Location of git files
info_dir2 = [info_dir1, 'IDW/'];
file_id2 = fopen([info_dir2, 'idw.csv'], "r");

% Read the header row (and discard it)
header = fgetl(file_id2);

% Read data rows: resource_IDs --> data1{i,1}; resource_names-->data1{i,2}
data2 = {};
while (!feof(file_id2))
  line2 = fgetl(file_id2);
  if (ischar(line2))
    row2 = strsplit(line2, ",");
    data2 = [data2; row2];
  end
end
fclose(file_id2);

% Construct the CSVs
for i = 1:rows(data2)
   download_function(data2{i,1}, api_key, data2{i,2}, info_dir2);
end

%% INPUTS 3 - HDF5

% Location of git files
info_dir3 = [info_dir1, 'HDF5/'];
file_id3 = fopen([info_dir3, 'hdf5.csv'], "r");

header = fgetl(file_id3); % Read the header row (and discard it)

% Read data rows: resource_IDs --> data1{i,1}; resource_names-->data1{i,2}
data3 = {};
while (!feof(file_id3))
  line3 = fgetl(file_id3);
  if (ischar(line3))
    row3 = strsplit(line3, ",");
    data3 = [data3; row3];
  end
end
fclose(file_id3);

% Construct the CSVs
for i = 1:rows(data3)
   download_function(data3{i,1}, api_key, data3{i,2}, info_dir3);
end
