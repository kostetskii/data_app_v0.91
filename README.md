# data_app_v0.91
Tiny data analysis utility (extraction, extrapolation and statistics) 

This code extracts data from many .csv's, sorts it and gives a possibility to 
- extrapolate data
- calculate statistics based on all input/extrapolated data or divide data by any number of groups and calculate it for each group. 
- plot data and statistics
- save .csv with the results of calculation

The data can be processed according to more, than 20 parameters (see comment 'SETTINGS' in the 'app_main' script).

The code is not well commented yet, but it'll be corrected soon.

- files:

  - merge_csv.m - extracts data from many .csv's, sorts data and creates an input .mat file for the 'app_main' script

  - corrupt_by_function.m - gives a possibility to multipy all the data by any function or add this function values to the part of  data, that correspond to 'Y' value

  - parse_groups.m - parses file with the group distribution of curves (the struct of this .csv is: first coulumn - GROUP_NAME,   second - CURVE_NUM. The sequence is random

  - app_main.m - main script with possibility of setting data processing and saving options

In the folders you can find an example of raw data, needed to be processed and the result of processing.
