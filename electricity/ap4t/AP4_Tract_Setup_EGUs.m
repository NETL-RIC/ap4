%% Tract-level SR matrix
% Marginal concentration matrices for input county
%
% CHANGELOG
% - swap height for size
% - Change lookup w/o table
% - Swap out protected variable, index for idx

eis = eis';
F = size(eis, 1); % number of input facilities
indices = zeros(F,1);
for n = 1:F
    % Indices of included facilities (idx is a scalar)
    % - note columns are ('row', 'fips', and 'eis')
    idx = AP4_EGU_List(AP4_EGU_List(:,3) == eis(n,1), 1);
    if size(idx, 1) ~= 1
        idx = idx(1);
    endif
    indices(n,1) = idx;
endfor

%% Tract-level SR matrix interpolation
% EGU Point sources
b = 3;
Trct_MC_EGU = cell(1,5);
Trct_MC_EGU{1,1} = read_database_mc(b,1)(indices,:); % nh3
Trct_MC_EGU{1,2} = read_database_mc(b,2)(indices,:); % nox
Trct_MC_EGU{1,3} = read_database_mc(b,3)(indices,:); % pmp
Trct_MC_EGU{1,4} = read_database_mc(b,4)(indices,:); % so2
Trct_MC_EGU{1,5} = read_database_mc(b,5)(indices,:); % voc

%% Initialize marginal damage matrices for storage and export
% EGU point sources
Results_MC	= cell(1,5); % marginal concentrations
MC_Tract_Matrix	= zeros(R,F);

if ~aqm_only
    Results_MM	= cell(1,5); % marginal mortality
    Results_MD	= cell(1,5); % marginal damages

    MM_Tract_Matrix	= zeros(R,F);
    MD_Tract_Matrix	= zeros(R,F);
endif

%% end of script.