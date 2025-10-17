%% County-to-tract interpolation
%
% CHANGELOG
% - swap height for size for AP4_Tract_List
% - remove distribute (no need to create new storage)
% - preallocate memory for DataBase_MC; reduces runtime from 6 hr to <6 min
% - replace Cnty_MC cells with read_cnty_mc(i,j)
% - [value] = read_cnty_mc(i,j) gives entire Cell, while read_cnty_mc(i,j)(1,1) provides single value

%% Tract-level matrix creation
t = size(AP4_Tract_List, 1);
num_b1 = size(read_cnty_mc(1,1), 1);
num_b2 = size(read_cnty_mc(2,1), 1);
num_b3 = size(read_cnty_mc(3,1), 1);
num_b = [num_b1 num_b2 num_b3];

% Initialize the database for holding all this data
% [m, n] = size(DataBase_MC); #3,5
% for a=1:m
%    for b=1:n
%        DataBase_MC{a, b} = zeros(num_b(1, a), t);
%    endfor
% endfor
% clearvars m n a b num_b1 num_b2 num_b3 num_b

# create folder for intermediate files
intermediate_dir = 'AP4_Tract_Intermediates/';

% Create folder for intermediate hdf files
if exist(intermediate_dir) ~= 7 #7 is a directory
    mkdir(intermediate_dir)
endif

int_path = [intermediate_dir 'DataBase_MC.h5']

for i = 1:3
    for j = 1:5
        dataset_name = sprintf('/%d/%d', i, j); 
        if (i < 3)
            h5create(int_path, dataset_name, [3108, 3108]);
        else 
            h5create(int_path, dataset_name, [1859, 3108]);
        endif
    end
end
clear dataset_name

for r = 1:t
    % Progress bar
    fprintf('Crosswalk: %3.3f\r', 100*r/t)

    % Selected counties for interpolation
    counties = idw(idw(:,1) == r, 2)';

    % Inverse distance weights
    weights = idw(idw(:,1) == r, 3)';

    % Tract-level matrix buildout
    % notably skips ground-level PM2.5 (1,3) and ground-level VOC (1,5)
    b = 1;
    for j = [1,2,4]
        dset = sprintf('/%d/%d', b, j);
        h5write(int_path, dset,sum(read_cnty_mc(b,j)(:,counties).*weights,2), [1,r]);
    end

    DataBase_MC{b,1}(:,r) = sum(read_cnty_mc(b,1)(:,counties).*weights,2);
    DataBase_MC{b,2}(:,r) = sum(read_cnty_mc(b,2)(:,counties).*weights,2);
    DataBase_MC{b,4}(:,r) = sum(read_cnty_mc(b,4)(:,counties).*weights,2);
    b = 2;
    DataBase_MC{b,1}(:,r) = sum(read_cnty_mc(b,1)(:,counties).*weights,2);
    DataBase_MC{b,2}(:,r) = sum(read_cnty_mc(b,2)(:,counties).*weights,2);
    DataBase_MC{b,3}(:,r) = sum(read_cnty_mc(b,3)(:,counties).*weights,2);
    DataBase_MC{b,4}(:,r) = sum(read_cnty_mc(b,4)(:,counties).*weights,2);
    DataBase_MC{b,5}(:,r) = sum(read_cnty_mc(b,5)(:,counties).*weights,2);
    b = 3;
    DataBase_MC{b,1}(:,r) = sum(read_cnty_mc(b,1)(:,counties).*weights,2);
    DataBase_MC{b,2}(:,r) = sum(read_cnty_mc(b,2)(:,counties).*weights,2);
    DataBase_MC{b,3}(:,r) = sum(read_cnty_mc(b,3)(:,counties).*weights,2);
    DataBase_MC{b,4}(:,r) = sum(read_cnty_mc(b,5)(:,counties).*weights,2);
endfor
fprintf('Crosswalk: %3.3f\n', 100*r/t);
clearvars counties weights b r t

%% end of script.