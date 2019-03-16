function [success] = add_csvheader(fileID, def_delim);

    try
        fprintf(fileID, '%s\n', ['sep=' def_delim]);
        success = 1;
    catch
        success = 0;
        warning('error adding a header to csv');
    end
    
end