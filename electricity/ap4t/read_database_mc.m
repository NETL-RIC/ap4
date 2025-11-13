function [value] = read_database_mc(i, j)
% read_database_mc - Read a single cell from current DataBase_MC HDF5 file.
%
% Syntax:
%   value = read_database_mc(i, j)
%
% Description:
%    This function reads the intermediate DataBase_MC HDF5 file created in
%    Crosswalk_County_to_Tract, which replaced the (3,5) DataBase_MC cell.
%    The HDF5 file is organized by groups (1-3) for the levels (ground,
%    non-EGU point, EGU point) and datasets (1-5) for air pollutants (i.e.,
%    NH3, NOx, PMP, SO2, and VOC).
%
% Inputs:
%   i - A scalar for the group level (1-3).
%   j - A scalar for the pollutant (1-5).
%
% Outputs:
%   value - A matrix of dimension (3108x72538) except for i=3, where the matrix
%           dimension is (1859x72538), reflecting the count of EGUs in the
%           model. If the DataBase_MC HDF5 file fails, returns NaN.

    % Set directory as global variable
    global dmc_file;

    % Recreate S._i._j naming to be consistent
    dataset_name = sprintf('/%d/%d', i, j);

    % Output matrix corresponding to i, j
    if exist(dmc_file) == 2
        value = h5read(dmc_file, dataset_name);
    else
        warning('Failed to read from DataBase_MC HDF5 file!')
        value = NaN;
    endif
end
