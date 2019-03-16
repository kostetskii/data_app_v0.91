function [success] = add_cell_to_csv(in_cell, fileID, delimiter)
    if nargin < 3
        delimiter = ',';
    end
    
    x_dim = length(in_cell(1,:));
    y_dim = length(in_cell(:,1));
    
    try
        for j=1:y_dim
            for i=1:x_dim
                item = in_cell{j,i};
                if isnumeric(item)
                    fprintf(fileID, '%f%s', round(item,2), delimiter);
                else
                    fprintf(fileID, '%s%s', item, delimiter);
                end
                if (i == x_dim)
                    fprintf(fileID, '\n');
                end
            end
        end
        success = 1;
    catch
        success = 0;
    end
end
