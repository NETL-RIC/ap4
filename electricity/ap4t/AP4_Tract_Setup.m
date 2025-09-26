%% Tract-level SR matrix
% Marginal concentration for input county
%
% CHANGELOG
% - New search for index w/o table
% - New County_Tract_List w/o table; note fips is column 2
%   - Swap 'height' for 'size'
% - add air quality model only if-statement
% - WARNING: protected function, index, overwritten; consider renaming, fips_id
%   fixed [25.05.08; TWD]
% - TODO: Preallocate memorty to Trct_MC

idx = AP4_County_List(AP4_County_List(:,2) == fips(f), 1);
Trct_MC = cell(2,5); % template for filling in; consider preallocating space

%% Tract-to-tract SR matrix pull
% Applicable for PM2.5-pri (PMP) & VOCs
% Calibration coefficients estimated using AP4 county-level impacts
run Tract_to_Tract_Calibration
Trct_MC{1,3} = read_tract_mc(idx,1).*Cal_PMP; % pmp
Trct_MC{1,5} = read_tract_mc(idx,1).*Cal_VOC; % voc

%% Tract-level SR matrix from interpolation
% Applicable for NH3, NOx, & SO2 and PMP & VOCs for point sources
% Ground-level
b = 1;
Trct_MC{b,1} = DataBase_MC{b,1}(idx,:); % nh3
Trct_MC{b,2} = DataBase_MC{b,2}(idx,:); % nox
Trct_MC{b,4} = DataBase_MC{b,4}(idx,:); % so2
% Point sources
b = 2;
Trct_MC{b,1} = DataBase_MC{b,1}(idx,:); % nh3
Trct_MC{b,2} = DataBase_MC{b,2}(idx,:); % nox
Trct_MC{b,3} = DataBase_MC{b,3}(idx,:); % pmp
Trct_MC{b,4} = DataBase_MC{b,4}(idx,:); % so2
Trct_MC{b,5} = DataBase_MC{b,5}(idx,:); % voc

%% Initialize source dimensions
% T = sources (i.e., tracts w/in specified county)
County_Tract_List = AP4_Tract_List(AP4_Tract_List(:,2) == fips(f), :);
T = size(County_Tract_List, 1); % number of source tracts

% Marginal concentrations (ground and non-EGU point sources)
Results_MC	= cell(2,5);
MC_Tract_Matrix	= zeros(R,T);

%% Initialize marginal damage matrices for storage and export
% Ground-level and non-EGU point sources
Results_MM	= cell(2,5); % marginal mortality
Results_MD	= cell(2,5); % marginal damages

if ~aqm_only
    MM_Tract_Matrix	= zeros(R,T);
    MD_Tract_Matrix	= zeros(R,T);
endif

%% Clean up
clear b

%% end of script.