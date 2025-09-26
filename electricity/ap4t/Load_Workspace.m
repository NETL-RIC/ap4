%% Load AP4_Tract workspace
% Pulls in maringal concentration matrices, inverse distance weighting
% criteria, population & mortality rate data, dose-response information,
% and willingness-to-pay & economic data
%
% CHANGELOG
% -  Export AP4_County_List.xlsx to CSV; remove headerline and all columns
%    except for the first two ('row' and 'id').
% -  Export AP4_EGU_List.xlsx to CSV; remove headerline and all columns
%    except for the first three ('row', 'fips', and 'eis').
% -  Export AP4_Tract_List.xlsx to CSV; remove headerline and all columns
%    except for the first four ('ap4', 'fips', 'tract', and 'id') and
%    converted tract IDs to numeric.
% -  The input directory, 'Tract_to_Tract' was provided by L. Dennin and
%    contains 3,108 CSV files
% -  In MATLAB, wrote out the 15 matrices for Cnty_MC to HDF5 (cnty_mc.h5)
% -  Remove the clear; it screws up a lot; consider replacing with variable
%    specification (e.g., clear AP4_*List)
% - Remove Load HDF 
% - Add hdf_dir as global variable

% Make sure you have a copy of the input CSVs
run Download_EDX_Tract

% Directory names
input_dir = 'AP4_Tract_Inputs/';
idw_dir = [input_dir 'IDW/'];
% makes hdf_dir global for h5read functions
global hdf_dir 
hdf_dir = [input_dir 'HDF5/'];

% Excel workbooks (as CSV files)
% Convert to integer the datasets that are only used for look ups
AP4_County_List = dlmread([input_dir 'AP4_County_List.csv'], ',');
AP4_County_List = uint16(AP4_County_List);

AP4_EGU_List = dlmread([input_dir 'AP4_EGU_List.csv'], ',');
AP4_EGU_List = uint32(AP4_EGU_List);

AP4_Tract_List = dlmread([input_dir 'AP4_Tract_List.csv'], ',');

% Tract-level population data by five-year age gaps
% (used for tract-to-county aggregation and health modeling)
Population_Data = cell(1,1);
Population_Data{1,1} = dlmread([input_dir 'population_2017.csv'], ' ');

%% Air Quality Model
% County-level marginal concentrations (from AP4)
% HDF5 FILE CREATED FROM MATLAB
% Note that i, j and the row and col numbers
% Therefore, S._1._1 is the 3108x3108 matrix for cell(1,1)
% NOTE 1: the 'load' method reads the whole HDF5 file to memory.
% NOTE 2: the 'load' method is commented out, and will be replaced with new h5read functions
%{ Cnty_MC = cell(3,5);
S = load([hdf_dir 'cnty_mc.h5'], '-hdf5');
for i=1:size(Cnty_MC, 1)
    for j=1:size(Cnty_MC, 2)
        Cnty_MC{i, j} = eval(['S._' num2str(i, '%i'), '._' num2str(j, '%i')]);
    endfor
endfor
clearvars S i j %}

%% Air Quality Model
% Inverse distance weighted data files
idw_cc03 = 'idw_dist_closest_3_counties.csv';
idw_cc05 = 'idw_dist_closest_5_counties.csv';
idw_cc10 = 'idw_dist_closest_10_counties.csv';
idw_w030 = 'idw_dist_counties_within_30_miles.csv';
idw_w050 = 'idw_dist_counties_within_50_miles.csv';
idw_w100 = 'idw_dist_counties_within_100_miles.csv';
idw_cal1 = 'idw_dist_own_and_adjacent_level_1_counties.csv';
idw_cal2 = 'idw_dist_own_and_adjacent_level_2_counties.csv';

% Inverse-distance weighted interpolation matrix
% - arguably, this should be read after the idw user selection to
%   avoid the overhead on computer memory (note, only 176 MB)
IDW_Distribution = cell(3,3);
IDW_Distribution{1,1} = dlmread([idw_dir idw_cc03], ',');
IDW_Distribution{1,2} = dlmread([idw_dir idw_cc05], ',');
IDW_Distribution{1,3} = dlmread([idw_dir idw_cc10], ',');
IDW_Distribution{2,1} = dlmread([idw_dir idw_w030], ',');
IDW_Distribution{2,2} = dlmread([idw_dir idw_w050], ',');
IDW_Distribution{2,3} = dlmread([idw_dir idw_w100], ',');
IDW_Distribution{3,1} = dlmread([idw_dir idw_cal1], ',');
IDW_Distribution{3,2} = dlmread([idw_dir idw_cal2], ',');
clearvars idw_cc03 idw_cc05 idw_cc10
clearvars idw_w030 idw_w050 idw_w100
clearvars idw_cal1 idw_cal2

% Tract-to-tract source-receptor matrix files
% HDF5 FILE CREATED IN MATLAB
% note: the group name is the column index
% load time: about two minutes (39.2 GB)
% NOTE: the 'load' method is commented out, and will be replaced with new h5read functions
%{Tract_to_Tract = cell(3108, 1);
S = load([hdf_dir 'tract_to_tract.h5'], '-hdf5');
for i=1:size(Tract_to_Tract, 1)
    Tract_to_Tract{i, 1} = eval(['S._' num2str(i, '%i')]);
endfor
clearvars S i%}
% find where hdf_dir

% New check for Air Quality Modeling only
if ~aqm_only
    %% Health Effects Model
    % Dose-response information
    DR_Info = dlmread([input_dir 'dr_info.csv']);

    %% Impacts Model
    % Gross domestic product data (1974--2020)
    GDP_Data = dlmread([input_dir 'gdp_info.csv'], ',');

    % Inflation data (2000--2020)
    Infl_Data = dlmread([input_dir 'inflation_info.csv'], ',');

    % Mortality rate data
    MR_Data = cell(1,1);
    MR_Data{1,1} = dlmread([input_dir 'mr_2017.csv'], ' ');

    % Willingness to pay info
    % The willingness to pay for mortality risk reductions
    % comes from two studies: USEPA (2006) = $7.4M and
    % Mrozek & Taylor, 2002 (1998) = $2.0M.
    % Column 2 is used to make values referenced to year 2012.
    WTP_Info = dlmread([input_dir 'vsl_info.csv'], ',');
endif

%% end of script.
