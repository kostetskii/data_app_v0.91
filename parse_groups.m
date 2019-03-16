clear all
clc
fprintf('#Running\n');
%% set load/save path
load_path = ['D:\Matlab code\data_app_v0.91\data_in\csv_raw\'];
save_path = ['D:\Matlab code\data_app_v0.91\data_in\csv_processed\'];
fname = 'groups';
%% check if load data exists
if ~exist(save_path, 'dir')
    mkdir(save_path);
    fprintf('#> save directory created\n');
elseif ~exist(load_path, 'dir')
    error(['path ' load_path ' does not exist']);
elseif ~exist([load_path fname '.xlsx'], 'file')
    error(['file ' load_path fname ' does not exist']);
end
%% init vars
raw_groups = [];
[~,~,crv_grp_data] = xlsread([load_path fname '.xlsx']);
crv_grp_data(end+1, [1,2]) = [{-1} {'DUMMY'}];
crv_group_len = length(crv_grp_data);
%% create cell with the next struct: 'GROUP_NAME' start_curve_ind end_curve_ind
start_group_indx = 1;

for i=1:crv_group_len
    if ~(i == 1)
        curr_grp = char(crv_grp_data(i, 2));
        prev_grp = char(crv_grp_data(i-1, 2));
        if ~(strcmp(curr_grp, prev_grp))
            grp_curves = {prev_grp start_group_indx i-1};
            raw_groups = [raw_groups; grp_curves];
            start_group_indx = i;
        end
    end
end
%% find same groups and change cell as next: 'GROUP_NAME' start_ind_1 end_ind_1 start_ind_2 end_ind_2 and replace repeated group row by zeros
group_col_len = length(raw_groups(:,1));
group_row_len = length(raw_groups(1,:));

len_table = zeros(group_col_len);
temp = [];
col=1;

for i=1:group_col_len
    len_table(i) = group_row_len;
    curr_grp = raw_groups(i,col);
    for k=(i+1):group_col_len
        if strcmp(raw_groups{i, col}, raw_groups{k, col})
            temp = [temp raw_groups{k,[col+1 col+2]}];
            raw_groups(i,[len_table(i)+1, len_table(i)+2]) = num2cell(temp);
            len_table(i) = len_table(i)+2;
            raw_groups(k,:) = num2cell(0);
            temp = [];
        end
    end
end
%% create a cell with no repeatings and zeros
row = 1;

for i=1:group_col_len
    if ~isequal(raw_groups(i, col),{0})
        groups_sorted(row,:) = raw_groups(i,:);
        row = row+1;
    end
end
%% save data
save_file_name = 'groups_sorted';
save([save_path save_file_name], save_file_name);
fprintf('#> DONE!\n');