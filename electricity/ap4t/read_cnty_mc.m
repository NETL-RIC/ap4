function [value] = read_cnty_mc(i,j)
    % set directory as global variable
    global hdf_dir 
    % inputs are [i,j] from (3,5) Cell
    file = [hdf_dir 'cnty_mc.h5'];
    dataset_name = sprintf('/%d/%d', i, j);  % recreate S._i._j naming to be consistent
    
    % outputs matrix corresponding to i,j
    value = h5read(file, dataset_name); 
end

% purpose: read a single value from cnty_mc.h5, e.g. read_cnty_mc(3,5)(1859,3108)