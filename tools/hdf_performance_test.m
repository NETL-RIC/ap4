% ----------------------------------------------------
% Octave Comprehensive Read Performance Test Script
% ----------------------------------------------------
%
% To compare chunking versus sequential data storage in
% DataBase_MC HDF5 file (as created in electricity/ap4t).
%
% --- 1. Configuration ---
num_repetitions = 10;  % How many rows to read
max_row_index = 1859;  % Maximum row index (based on HDF5 dimension)

% List of all populated dataset paths (skipping the empty ones: /1/3 and /1/5)
dataset_paths = {
    '/1/1', '/1/2', '/1/4' ...
    '/2/1', '/2/2', '/2/3', '/2/4', '/2/5' ...
    '/3/1', '/3/2', '/3/3', '/3/4', '/3/5'
};

num_datasets = numel(dataset_paths);
total_reads = num_repetitions * num_datasets;

% Pre-allocate random indices
all_indices = randi(max_row_index, 1, total_reads);

% --- 2. Test Function ---
function total_time = test_read_performance(filename, paths, num_reps, all_indices)
    % Pre-allocate result storage container
    read_data_storage = cell(num_reps, numel(paths));

    % Index for pre-generated indices
    idx_counter = 1;

    % Initialize time and start timer
    tic;

    % Loop for the specified number of repetitions (outer loop)
    for k = 1:num_reps
        % Loop through every populated dataset (inner loop)
        for i = 1:numel(paths)
            dset_name = paths{i};

            % Use pre-allocated index
            row_idx = all_indices(idx_counter);

            % Perform the critical HDF5 read operation (accessing the Octave
            % row). The dimensions are 3108x72538 for groups 1 & 2 and
            % 1809x72538 for group 3. Read the first value in a random column.
            data_val = h5read(filename, dset_name)(row_idx, 1);
            read_data_storage{k, i} = data_val;

            % Increment random index counter
            idx_counter = idx_counter + 1;
        endfor
    endfor

    total_time = toc;
endfunction

% --- 3. Execute Tests ---
printf('Starting HDF5 Read Performance Tests (%d reads per dataset, 13 datasets total)...\n', num_reps);

% --- File A: Original Contiguous File ---
disp('Testing original contiguous HDF5...');
time_contiguous = test_read_performance(
    'DataBase_MC-IDW_12.h5',
    dataset_paths,
    num_repetitions,
    all_indices
);

% --- File B: Chunked File (No Compression) ---
disp('Testing chunked with no compression HDF5...');
time_chunked = test_read_performance(
    'DataBase_MC-IDW_32cu.h5',
    dataset_paths,
    num_repetitions,
    all_indices
);

% --- 4. Report Results ---
disp('----------------------------------');
printf('Total Contiguous Read Time: %.2f seconds\n', time_contiguous);
printf('Total Chunked Read Time: %.2f seconds\n', time_chunked);

% Calculate speedup
if (time_contiguous > time_chunked)
    speedup = time_contiguous / time_chunked;
    printf('Chunking Speedup: %.2fx faster\n', speedup);
    disp('Conclusion: Chunking is a worthwhile optimization. Use the chunked file.');
else
    printf('Chunking did not result in a speedup.\n');
    disp('Conclusion: Stick with the contiguous layout for simplicity and slightly faster file opening.');
endif
