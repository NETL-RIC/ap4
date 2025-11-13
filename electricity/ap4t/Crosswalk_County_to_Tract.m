%% County-to-tract interpolation
% Creates variables,
% - t (number of tracts)
% - intermediate_dir (AP4_Tract_Intermediates folder)
% - dmc_file (file path to DataBase_MC HDF5)
%
% CHANGELOG & NOTES
% - swap height for size for AP4_Tract_List
% - remove distribute (no need to create new storage)
% - preallocate memory for DataBase_MC; reduces runtime from 6 hr to <6 min
% - replace Cnty_MC cells with read_cnty_mc(i,j)
% - [value] = read_cnty_mc(i,j) gives entire Cell, while
%   read_cnty_mc(i,j)(1,1) provides single value

%% Tract-level matrix creation
t = size(AP4_Tract_List, 1);

% Initialize the database for holding all this data
% NEW: replace the following initialization with HDF5 read/write

% ------------------------------ OLD CODE -------------------------------------
% num_b1 = size(read_cnty_mc(1,1), 1);
% num_b2 = size(read_cnty_mc(2,1), 1);
% num_b3 = size(read_cnty_mc(3,1), 1);
% num_b = [num_b1 num_b2 num_b3];
% [m, n] = size(DataBase_MC); # 3,5
% for a=1:m
%    for b=1:n
%        DataBase_MC{a, b} = zeros(num_b(1, a), t);
%    endfor
% endfor
% clearvars m n a b num_b1 num_b2 num_b3 num_b
% -----------------------------------------------------------------------------

% NEW: Addresses issue #5
% Create a folder for intermediate files
intermediate_dir = 'AP4_Tract_Intermediates/';

if exist(intermediate_dir) ~= 7 % reminder that 7 is an existing directory
    mkdir(intermediate_dir)
endif

% Create DataBase_MC HDF5, which is used in the AP4_Tract_Setup and
% AP4_Tract_Setup_EGUs modules. Use a dynamic file name because there is more
% than one IDW selection.
%   11/11/25: Created 1,2 HDF5 file in 130676 s (36.3 h) on macOS.
int_base_file = 'DataBase_MC';
int_base_ext = '.h5';
int_dynamic = sprintf('-IDW_%d%d', idw_meth, idw_spec);
global dmc_file;
dmc_file = [intermediate_dir int_base_file int_dynamic int_base_ext];
clearvars int_base_file int_base_ext int_dynamic

if exist(dmc_file) ~= 2
    % Create the HDF5 file and its groups and datasets
    for i = 1:3
        for j = 1:5
            % HOTFIX: Skip the creation of datasets /1/3 and /1/5 [251113;TWD]
            if (i == 1 && (j == 3 || j == 5))
                continue;
            endif

            dataset_name = sprintf('/%d/%d', i, j);
            % HOTFIX: column dim of Database_MC should be 't' [251109;TWD]
            if (i < 3)
                h5create(dmc_file, dataset_name, [3108, t]);
            else
                h5create(dmc_file, dataset_name, [1859, t]);
            endif
        endfor
    endfor
    clearvars dataset_name i j

    % Build out the HDF5 file; this takes a long while!
    for r = 1:t
        % Progress bar
        fprintf('Crosswalk: %3.3f\r', 100*r/t)

        % For each tract, extract the IDW list of counties and tract-county
        % weights:
        counties = idw(idw(:,1) == r, 2)';
        weights = idw(idw(:,1) == r, 3)';

        % Tract-level matrix build-out
        %   Loop over b (ground, non-EGU point, and EGU point) and for each b,
        %   loop over j (i.e., the five criteria pollutants) and perform the
        %   IDW interpolation for it.
        for b = 1:3
            for j = 1:5
                % notably skips ground-level PM2.5 (1,3) and VOC (1,5)
                if b == 1 && (j == 3 || j == 5)
                    continue;
                endif

                try
                    dset = sprintf('/%d/%d', b, j);
                    % TODO: test run with dvec only (skip h5write)
                    dvec = sum(read_cnty_mc(b, j)(:, counties).*weights, 2);
                    dsze = size(dvec);
                    h5write(dmc_file, dset, dvec, [1, r], dsze);
                catch
                    disp(" ")
                    disp("Failed to write to HDF5")
                    disp(sprintf("r = %d; b = %d; j = %d", r, b, j))
                    disp(" ")
                end
            endfor
        endfor
    endfor

    fprintf('Crosswalk: %3.3f\n', 100*r/t);
    clearvars counties weights b j r t dset dvec dsze

endif

%% end of script.