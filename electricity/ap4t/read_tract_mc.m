function [value] = read_tract_mc(i)
% read_tract_mc - Read a single cell from Tract_to_Tract HDF5 file.
%
% Syntax:
%   value = read_tract_mc(i)
%
% Description:
%   This function replaces the (3108,1) Tract_to_Tract cell originally
%   populated in Load_Workspace. The rows represent U.S. counties. Each
%   cell is a matrix where the rows are the tracts found in that county
%   (variable in length) by total tracts (72,538), resulting in tract-to-tract
%   connections for each county. The HDF file is organized with a single
%   root group and datasets representing the row indices of the cell.
%
% Inputs:
%   i - Scalar representing the row index for a given county (1-3108).
%
% Outputs:
%   value - Matrix of variable row length and 72,538 columns.

    % Set directory as global variable
    global hdf_dir

    file = [hdf_dir 'tract_to_tract.h5'];

    % Recreate S._i. naming to be consistent
    dataset_name = sprintf('/%d', i);

    % Output matrix corresponding to i
    value = h5read(file, dataset_name);
end
