clear
clc
fprintf('#Running\n');
%%
corrupt = 1;
del_to_point = 1;
%%
y_multipier = 16; %192
max_scale_val = 1.28 %2.56
x_move = 0;   %0.15 %0.15
%%
del_to = 15.9; %15.9
%%
y_col = 7;
crv_num_col = 2;
x_col = 1;
curves = 128;
%%
load_path = 'D:\Matlab code\data_app_v0.91\data_in\csv_processed\';
load_file_name = 'csv_sorted';
mtp_save_path = 'D:\Matlab code\data_app_v0.91\data_in\csv_processed\multipied\';
%%
if ~exist(mtp_save_path, 'dir')
    mkdir(mtp_save_path);
    fprintf('#> save directory created\n');
elseif ~exist(load_path, 'dir')
    error(['path ' load_path ' does not exist']);
elseif ~exist([load_path load_file_name '.mat'], 'file')
    error(['file ' load_path load_file_name ' does not exist']);
end

%%
load([load_path load_file_name]);
multipied_data = csv_sorted;
%%
csv_len = length(multipied_data(:, y_col));
if corrupt
    for crv = 1:curves;
        curr_indxs = find(multipied_data(:, crv_num_col) == crv);
        curr_dat_len = length(curr_indxs);
        
        curr_x = (multipied_data(curr_indxs, x_col));
        maxval = max(curr_x);
        rescaled = curr_x/maxval*max_scale_val+x_move;
        
        vals_to_add = y_multipier*(1./rescaled);
        multipied_data(curr_indxs, y_col) = ...
            multipied_data(curr_indxs, y_col) + vals_to_add;
        fprintf('#> corrupting %d of %d\n', crv, curves);
    end
end
%%
new_mult_data = [];
if del_to_point
    for crv = 1:curves
        curr_indxs = find(multipied_data(:, crv_num_col) == crv);
        indxs_needed = find(round(multipied_data(curr_indxs, x_col)/86400, 1) == del_to);
        
        indx = indxs_needed(1);
        x_val = multipied_data(indx, x_col);
        
        new_indxs = curr_indxs(indx:end);
        new_data = multipied_data(new_indxs, :);
        
        new_data(:, x_col) = new_data(:, x_col)-x_val;
        new_mult_data = [new_mult_data; new_data];
        fprintf('#> cutting %d of %d\n', crv, curves);
    end
    multipied_data = new_mult_data;
end
%%
save([mtp_save_path 'multipied_data.mat'], 'multipied_data');
fprintf('***EEEEEEEE, data is corrupted & cut***\n');