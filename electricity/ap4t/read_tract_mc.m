function [value] = read_tract_mc(i)
    % set directory as global variable
    global hdf_dir 
    % inputs are [i] from (3108,1) Cell (NO groups, they are all datasets (variable # col, 72357)
    file = [hdf_dir 'tract_to_tract.h5'];
    dataset_name = sprintf('/%d', i);  % recreate S._i. naming to be consistent
    
    % outputs matrix corresponding to i
    value = h5read(file, dataset_name); 
end