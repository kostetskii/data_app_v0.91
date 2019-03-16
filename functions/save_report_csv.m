function [success] = save_report_csv(file_n, mdata_arr, cell_to_write, def_delim)
    try 
        file = fopen(file_n, 'w');
        if add_csvheader(file, def_delim) && add_cell_to_csv(mdata_arr, file, ' ');
            sub_success_0 = 1;
        else
            sub_success_0 = 0;
        end
        
        fprintf(file, '\n%s\n\n', 'REPORT_DATA:');
        if add_cell_to_csv(cell_to_write, file, def_delim);
            sub_success_1 = 1;
        else
            sub_success_1 = 0;
        end
        fclose('all');
        success = sub_success_0 * sub_success_1;
    catch
        success = 0;
        fclose('all');
        warning('ERROR WHILE SAVING, CHECK CURRENT CODE');
    end
end