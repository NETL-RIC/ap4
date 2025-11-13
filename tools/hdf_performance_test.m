% ----------------------------------------------------
% Octave Comprehensive Read Performance Test Script
% ----------------------------------------------------
%
% To compare chunking versus sequential data storage in
% DataBase_MC HDF5 file (as created in electricity/ap4t).
%
% --- 1. Configuration ---
num_repetitions = 1000; % Number of row reads per dataset
max_row_index = 72538;  % Maximum row index (based on HDF5 dimension)

% List of all populated dataset paths (skipping the empty ones: /1/3 and /1/5)
dataset_paths = {
    '/1/1', '/1/2', '/1/4'; ...
    '/2/1', '/2/2', '/2/3', '/2/4', '/2/5'; ...
    '/3/1', '/3/2', '/3/3', '/3/4', '/3/5'
};

% --- 2. Test Function ---
function total_time = test_read_performance(filename, paths, num_reps, max_row)
    % Initialize time and start timer
    tic;

    % Loop for the specified number of repetitions (outer loop)
    for k = 1:num_reps
        % Loop through every populated dataset (inner loop)
        for i = 1:numel(paths)
            dset_name = paths{i};

            % Generate a random row index for the 72538 dimension
            % Note: Octave uses 1-based indexing
            row_idx = randi(max_row);

            % Determine the column length for the current dataset group (3108 or 1859)
            if (i <= 8) % Corresponds to Groups 1 and 2
                col_len = 3108;
            else % Corresponds to Group 3
                col_len = 1859;
            endif

            % Perform the critical HDF5 read operation (accessing the Octave
            % row) [start_row, start_col], [num_rows, num_cols]
            % Since Octave views the data as 3108x72538, we read 1
            % row x 72538 cols; however, the Octave h5read function expects the
            % dimensions in the Octave order but the indexing logic must align
            % with the Octave matrix dimensions.

            % The HDF5 file is 72538x3108 in C-order.
            % Octave presents it as 3108x72538.
            % We need to read the row index out of the 3108 dimension.

            % Correct Octave h5read syntax for reading a single Octave row:
            % Octave treats the matrix as (3108 ROWS, 72538 COLUMNS).
            data_row = h5read(filename, dset_name, [row_idx, 1], [1, col_len]);

            % Minimal work to ensure data is processed and not optimized out
            sum_val = sum(data_row);
        endfor
    endfor

    total_time = toc;
endfunction

% --- 3. Execute Tests ---
printf('Starting HDF5 Read Performance Tests (%d reads per dataset, 13 datasets total)...\n', num_reps);

% --- File A: Original Contiguous File ---
disp('Testing original contiguous HDF5...');
time_contiguous = test_read_performance(
    'DataBase_MC.h5',
    dataset_paths,
    num_repetitions,
    max_row_index
);

% --- File B: Chunked File (No Compression) ---
disp('Testing chunked with no compression HDF5...');
time_chunked = test_read_performance(
    'DataBase_MC_chunk.h5',
    dataset_paths,
    num_repetitions,
    max_row_index
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
