clear all
clc
fprintf('#Running\n');
%% set pathes
files_q = 167;
fname = 'SysTwoLog';
csv_path = 'D:\Matlab code\data_app_v0.91\data_in\csv_raw\csvs\';
save_path = 'D:\Matlab code\data_app_v0.91\data_in\csv_processed\';
%% check if data exists
if ~exist(save_path, 'dir')
    mkdir(save_path);
    fprintf('#> save directory created\n');
elseif ~exist(csv_path, 'dir')
    error(['path ' csv_path ' does not exist']);
elseif ~exist([csv_path fname '1.csv'], 'file')
    error(['file ' csv_path fname ' does not exist']);
end
%% read csv
NUM = [];
TXT = [];
for i=1:files_q
    [dataN dataT dataR] = xlsread([csv_path fname num2str(i) '.csv']);
    NUM = [NUM; dataN];
    TXT = [TXT; dataT];
    if mod(i,5)==0
        fprintf('> reading %dth file of %d\n', i, files_q);
    end
end
%% calculate relative time
txtlen = length(TXT);
DATE = [];

for k=1:txtlen
    t1 = datevec(TXT{1});
    t2 = datevec(TXT{k});
    pure_time = etime(t2,t1);
    DATE(k) = pure_time;
    if mod(k,500)==0
        fprintf('> %d of %d dates processed\n', k, txtlen);
    end
end
%% create output files and save
csvs_all = [DATE' NUM];
csv_sorted = sortrows(csvs_all, 2);
save_file_name = 'csv_sorted';
save([save_path save_file_name], save_file_name);
fprintf(['#> DONE!\n']);