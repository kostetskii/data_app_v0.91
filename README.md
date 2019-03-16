# data_app_v0.91
Tiny data analysis utility (extraction, extrapolation and statistics) 

This code extracts data from .csv with specific structure and processes it according to the set parameters (see main file)

files:

- merge_csv.m - extracts data from many .csv's, sorts data and creates an input .mat file for the 'app_main' script

- corrupt_by_function.m - gives a possibility to multipy all the data by any function or add this function values to the part of data, that correspond to 'Y' value

- parse_groups.m - parses file with the group distribution of curves (the struct of this .csv is: first coulumn - GROUP_NAME, second - CURVE_NUM. The sequence is random

- app_main.m - main script with possibility of setting data processing and saving options

- files, that aren't described here are functions

New comments will be added soon
