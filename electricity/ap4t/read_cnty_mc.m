function [value] = read_cnty_mc(i,j)
% read_cnty_mc - Read a single cell from Cnty_MC HDF5 file.
%
% Syntax:
%   value = read_cnty_mc(i, j)
%
% Description:
%   This function replaces the in-memory version of the (3,5) Cnty_MC cell.
%   The data are now stored in HDF5 format where the group (1-3) is the level
%   (e.g., ground non-point; ground non-EGU point; EGU point) and the
%   dataset (1-5) is the air pollutant (i.e., NH3, NOx, PMP, SO2, and VOC).
%
% Inputs:
%   i - A scalar for the group level (1-3).
%   j - A scalar for the pollutant (1-5).
%
% Outputs:
%   value - A matrix of dimension (3108x3108) except for i=3, where the matrix
%           dimension is (1859x3108), reflecting the count of EGUs in the model.
%
% Example:
%   >> single_value = read_cnty_mc(3, 5)(1859, 3108)

    % Set directory as global variable
    global hdf_dir

    file = [hdf_dir 'cnty_mc.h5'];

    % Recreate S._i._j naming to be consistent
    dataset_name = sprintf('/%d/%d', i, j);

    % Output matrix corresponding to i, j
    value = h5read(file, dataset_name);
end
