clear
clc
fprintf('#Running\n');
addpath('D:\Matlab code\data_app_v0.91\scripts\funcs\');
%% ================================= SETTINGS ==================================
%% data processing options
x_ref_val = 365;
x_shift = .3;
x_from = x_shift;
x_to = 132;%1.25*x_ref_val;
x_points_needed = [64 96 118 130];%[0.6 0.75 0.9 1.05 1.2]*x_ref_val;
x_divider = 86400;
extrap_from = 9/10;
y_scale_lims = [-350, 0];
sigma_mult = 3;
stat_accuracy = 1;
%% flags
stat = 1;
groups = 1;
x_lines = 1;
reduce_plot_size = 1;
save_report_data = 1;
%% data selection
x_col = 1;
y_col = 7;
curve_col = 2;
start_curve = 1;
end_curve = 92;
not_curve = 0;
subscript = 'demo data';
%% data saving/loading options
input_file_name = 'multipied_data.mat';
group_div_file = 'groups_sorted.mat';
save_path = 'D:\Matlab code\data_app_v0.91\saved\';
data_path = 'D:\Matlab code\data_app_v0.91\data_in\csv_processed\multipied\';
group_file_path = 'D:\Matlab code\data_app_v0.91\data_in\csv_processed\';
%% ============================= END OF SETTINGS ===============================
%% constants
av_symb = ['^', '<', '>', 'v', 'o', 's', 'd', 'p', 'h', '*', 'x', '+'];
markersize = 6;
legend_str = {};
x = [x_ref_val, x_ref_val];
%%
if ~exist(save_path, 'dir')
    mkdir(save_path);
    fprintf('#> save path created\n');
end
%% calculated data arrays
total_removed = 0;
data_extrap.group_y = [];
data_extrap.x = [];
data_in.y = [];
sigma_all_groups = [];
mean_y_all_groups = [];
p_6sigma_all_groups = [];
m_6sigma_all_groups = [];
int_max_all_groups = [];
int_min_all_groups = [];
all_x = {};
all_y = {};
%% plot colors
data_clr = {'r', 'g', 'b', 'y', 'c', 'm',...
    'r-.', 'g-.', 'b-.', 'y-.', 'c-.', 'm-.'};   
extrap_clr = {'m', 'y', 'c', 'g', 'b', 'r',...
    'm-.', 'y-.', 'c-.', 'g-.', 'b-.', 'r-.'};
%% load data and create save dir
try
    load([data_path input_file_name]);
    load([group_file_path group_div_file]);
    fprintf('#> data loaded\n');
catch
    error('DIR DOES NOT EXIST OR MISSING DATA FILES');
end
%% find the less col len and cut all the data to min length
len_y_arr = zeros(1,end_curve-start_curve+1);
len_x_arr = zeros(1,end_curve-start_curve+1);
item = 1;
len_arr = zeros(1, end_curve-start_curve+1);
for curr_curve=start_curve:end_curve
    curr_curve_indx = find(multipied_data(:,curve_col) == curr_curve); 
    len_arr(item) = length(curr_curve_indx);
    item = item+1;
end
min_col_len = min(len_arr(:));
extrap_offs = round(min_col_len*extrap_from);                                           % shift from center while collecting data to extrapolate
%% create input data structure
fprintf('#> processing loaded data\n');
[data_in.x, data_in.y] = create_input_struct(start_curve, end_curve, not_curve,...
    multipied_data, x_shift, x_col, curve_col, y_col, min_col_len, x_divider);
last_x = max(data_in.x(end,:));

if x_to > last_x
    extrapolate = 1;
else
    extrapolate = 0;
end
%% generate plot title
if x_shift == 0
    pl_title = ['no x shift, ' subscript];
else
    pl_title = ['shifted to ' num2str(x_shift) ' x-scale units, ' subscript];
end
%% make fig
x_lbl = 'x-scale label, Xunits';
y_lbl = 'y-scale label, Yunits';
new_fig(x_lbl, y_lbl, [x_from x_to], y_scale_lims, pl_title);
%% if no division by gruops
if ~groups
    groups_sorted = [{'all data'}, num2cell(start_curve), num2cell(end_curve)];
    first_row_needed = 1;
    last_row_needed = 1;
end
%% create group-curve data structure and find first and last group names needed and referred curves
fprintf('#> reading group distribution file\n');
[curves_in_group, first_row_needed, last_row_needed] = ...
    parse_group_file(groups_sorted, start_curve, end_curve);
%% check if found group with start/end group needed
if groups && ((last_row_needed == -1) || (first_row_needed == -1))
    fprintf(['\nERR: cannot process data for a part of group.\n'...
        'Only all curves, referred to the group can be plotted with "groups" enabled\n']);
    return
end
%% parse group-curve data structure
group_delim_indxs = find(curves_in_group(:) == 0);
for grp=first_row_needed:last_row_needed
    group_end_indx = group_delim_indxs(grp);
    
    if ~(grp == 1)
        group_start_indx = group_delim_indxs(grp-1)+1;
    elseif grp == 1
        group_start_indx = 1;
    end
    
    curr_group_crvs = curves_in_group(group_start_indx:group_end_indx-1);
    curr_group_len = length(curr_group_crvs);
    for i=1:curr_group_len
        curr_crv = curr_group_crvs(i)-start_curve+1;
%% reduce input data size, if needed and possible
        if reduce_plot_size
            [data_in.x_plot, data_in.y_plot, deleted] = reduce_data_size(data_in.x,...
                data_in.y(:,curr_crv), 4);
            total_removed = total_removed + deleted;
        else
            data_in.x_plot = data_in.x; 
            data_in.y_plot = data_in.y(:,curr_crv);
        end
        if ~groups
            plot(data_in.x_plot, data_in.y_plot, 'linewidth', 1);
        elseif groups
            plot(data_in.x_plot, data_in.y_plot, data_clr{grp-first_row_needed+1}, 'linewidth', 1);
        end
        legend_str = [legend_str [char(groups_sorted(grp,1)) ' (curve' num2str(curr_crv) ')']];
%% extrapolate and plot data        
        if extrapolate
            [data_extrap.curr(:, 1) data_extrap.curr(:, 2)] = ...
                curve_extrap(data_in.x, data_in.y(:,curr_crv), x_to,...
                extrap_clr{grp-first_row_needed+1}, extrap_offs, reduce_plot_size);
            legend_str = [legend_str [char(groups_sorted(grp,1)) ' (curve' num2str(curr_crv) ')extrap']];
            data_extrap.group_y = [data_extrap.group_y, data_extrap.curr(:, 2)];
            data_extrap.x = data_extrap.curr(:,1);
        end
    end
%% create cell with all data, sorted by groups
    if (grp == 1)
        all_x = {[data_in.x; data_extrap.x]};
    end
    all_y(grp) = {[data_in.y(:,curr_group_crvs-start_curve+1); data_extrap.group_y]};
%% save extrapolation data and clear Y for current group
    data_extrap.group_y = [];
end
%% calculate statistics for each group
for group = 1:length(all_y)
    x_points_num = length(x_points_needed);
    if stat
        fprintf('#> calculating statistics for %s\n', char(groups_sorted(grp,1)));
        try
            data_extrap_full = [all_x{1}, all_y{group}];
            [sigma, mean_y, x_indxs] = get_stat(data_extrap_full, (x_points_needed), stat_accuracy);
        catch
            warning('INCORRECT DATA PROCESSING SETTINGS OR NO MATHING POINTS %s', stat);
            sigma = 'err';
            mean_y = 'err';
            x_indxs = 'err';
        end
%% plot statistics
        if ~strcmp(mean_y, 'err') && ~strcmp(sigma, 'err')
            x_pos = x_points_needed;
            text_offs = 3;
            for i=1:x_points_num
                UL(i) = sigma_mult.*sigma(i) + mean_y(i);
                LL(i) = mean_y(i) - sigma_mult.*sigma(i);
                plot(x_pos(i), mean_y(i)+sigma_mult*sigma(i), [data_clr{group} '^'], 'markersize', markersize);
                legend_str = [legend_str [num2str(sigma_mult) '*sigma_' char(groups_sorted(group,1))]];
                plot(x_pos(i), mean_y(i), ['k' av_symb(group)], 'markersize', markersize+2);
                legend_str = [legend_str ['mean_' char(groups_sorted(grp,1))]];
                plot(x_pos(i), mean_y(i)-sigma_mult*sigma(i), [data_clr{group} '^'], 'markersize', markersize);
                legend_str = [legend_str ['-' num2str(sigma_mult) '*sigma_' char(groups_sorted(group,1))]];
%% add subscripts
                text(x_pos(i)+text_offs, mean_y(i)+sigma_mult*sigma(i), ['\mu+' num2str(sigma_mult) '\sigma '  char(groups_sorted(group,1))]);
                text(x_pos(i)+text_offs, mean_y(i)-sigma_mult*sigma(i), ['\mu-' num2str(sigma_mult) '\sigma ' char(groups_sorted(group,1))]);
                text(x_pos(i)+text_offs, mean_y(i), ['\mu ' char(groups_sorted(group,1))]);
            end
%% save statistics data            
            sigma_all_groups = [sigma_all_groups round(sigma',1)];
            mean_y_all_groups = [mean_y_all_groups round(mean_y',1)];
            p_6sigma_all_groups = [p_6sigma_all_groups round(UL',1)];
            m_6sigma_all_groups = [m_6sigma_all_groups round(LL',1)];
%% find intersections
            for i=1:x_points_num
                x_val = (x_points_needed(i));
                [int_max(i), int_min(i)] = group_intersect(x_val, all_x{1}, all_y{group}, stat_accuracy);
            end
            int_max_all_groups = [int_max_all_groups round(int_max',2)];
            int_min_all_groups = [int_min_all_groups round(int_min',2)];
        end
    end
end
fprintf('#> points removed from raw data: %d\n', total_removed);
%% add x verical lines in points (x_point_needed variable)
if x_lines
    for m = 1:x_points_num
        plot([1 1].*x_points_needed(m), y_scale_lims, '--k', 'linewidth', 1);
        txt = ' Xunits';
        x_val = x_points_needed(m);
        text_sub = text(x_points_needed(m), (y_scale_lims(2)-...
            ((y_scale_lims(2)-y_scale_lims(1))/20)),...
            [num2str(x_val) txt], 'BackgroundColor', 'w');
        set(text_sub, 'Rotation', 0);
    end
end
%% set legend
legend(legend_str, 'location', 'eastoutside');
legend(gca,'off');
grid on;
%% create table with calculated data
if stat
    fprintf('#> generating table with stat for %s\n', subscript);
    vals_col = [{'X_vals'}, {'groups'}, {'mu'}, {'sigma'},...
        {['mu+' num2str(sigma_mult) 'sigma']},...
        {['mu-' num2str(sigma_mult) 'sigma']},...
        {'Int_max'}, {'Int_min'}];
    sigma_row = [];
    mean_row = [];
    p_6sigma_row = [];
    m_6sigma_row = [];
    all_points_title_row = [{}];
    one_point_title_row = [{}];
    int_max_row = [];
    int_min_row = [];
    x_row = [{}];
%% create single time point subrow
    for i=first_row_needed:last_row_needed
        one_point_title_row = [one_point_title_row char(groups_sorted(i,1))];
    end
    one_point_title_row = [one_point_title_row {'min'} {'max'}];
%% create first row as cell array    
    k=1;
    one_point_subrow_len = length(one_point_title_row);
    for i=1:(one_point_subrow_len*x_points_num)
        if (x_points_needed(1) < 1*x_ref_val)
            curr_x = x_points_needed(k);
        else
            curr_x = x_points_needed(k);
        end
        if (rem(i,one_point_subrow_len) == 0)            
            k = k+1;
        end
        x_row = [x_row curr_x];
    end
%% create rows with data
    for yr=1:x_points_num
        all_points_title_row = [all_points_title_row one_point_title_row];
        [min_s, ~] = min(sigma_all_groups(yr,:));
        [max_s, ~] = max(sigma_all_groups(yr,:));
        sigma_row = [sigma_row sigma_all_groups(yr,:) min_s max_s];
        [min_mu, ~] = min(mean_y_all_groups(yr,:));
        [max_mu, ~] = max(mean_y_all_groups(yr,:));
        mean_row = [mean_row mean_y_all_groups(yr,:) min_mu max_mu];
        [min_p6s, ~] = min(p_6sigma_all_groups(yr,:));
        [max_p6s, ~] = max(p_6sigma_all_groups(yr,:));
        p_6sigma_row = [p_6sigma_row p_6sigma_all_groups(yr,:) min_p6s max_p6s];
        [min_m6s, ~] = min(m_6sigma_all_groups(yr,:));
        [max_m6s, ~] = max(m_6sigma_all_groups(yr,:));
        m_6sigma_row = [m_6sigma_row m_6sigma_all_groups(yr,:) min_m6s max_m6s];
        [min_min_int, ~] = min(int_min_all_groups(yr,:));
        [max_min_int, ~] = max(int_min_all_groups(yr,:));
        int_min_row = [int_min_row int_min_all_groups(yr,:) min_min_int max_min_int];
        [min_max_int, ~] = min(int_max_all_groups(yr,:));
        [max_max_int, ~] = max(int_max_all_groups(yr,:));
        int_max_row = [int_max_row int_max_all_groups(yr,:) min_max_int max_max_int];
    end
%% final structure with data
    CALCULATED = [x_row(:)'; all_points_title_row(:)'; num2cell(mean_row(:)'); ...
        num2cell(sigma_row(:)'); num2cell(p_6sigma_row(:)');...
        num2cell(m_6sigma_row(:)'); num2cell(int_max_row(:)');...
        num2cell(int_min_row(:)')]; 
    CALCULATED_TAB = [cellstr(vals_col(:)) CALCULATED];                          % all stat data cell
%% save report data
    if save_report_data
        curr_date = char(datetime);
        date_only = curr_date(1:11);
        fprintf('#> saving data for %s\n', subscript)
        file_name = [save_path subscript '_shifted_to_' num2str(x_shift)...
            '_x_units_' date_only '_' num2str(now) '.csv'];
        metadata_names = [{'METADATA:'}, {'subscript: '},...
            {'max_x: '}, {'x_shift: '},...
            {'from_x: '}, {'to_x: '}, {'generated: '}];
        metadata_vals = [{''}, {subscript}, {last_x},...
            {x_shift}, {x_from}, {x_to}, {datestr(datetime)}];
        metadata_arr = [metadata_names' metadata_vals'];
        
        if save_report_csv(file_name, metadata_arr, CALCULATED_TAB, ',');
            fprintf('#> data saved\n');
        else
            warning('data has not been saved');
        end
    end
end
%% done
fprintf('#> DONE!\n');