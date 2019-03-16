function [curves_in_group, from_row, to_row] = parse_group_file(groups_array, first_crv, last_crv)

    group_rows = length(groups_array(:,1));                                   
    group_cols = length(groups_array(1,:));
    groups_array(:, group_cols+1) = {-1};
    curves_in_group = [];
%% make an array with all needed crvs ([crvs_referred_to_curr_group, 0, crvs_referred_to_next_group, 0, ...])
    from_row = -1;
    to_row = -1;
    
    for row=1:group_rows
        for col=2:group_cols+1
            
            if (rem(col,2) == 0) && isequal((groups_array(row,col)), {-1})
                curves_in_group = [curves_in_group 0];
            elseif (rem(col,2) == 0) && ~(isequal(groups_array(row,col), {[]}))
                curves_in_group = [curves_in_group [cell2mat(groups_array(row,col)):...
                    cell2mat(groups_array(row,col+1))]];
            end
            
            if (cell2mat(groups_array(row,col)) == last_crv)
                if ~(rem(col, 2) == 0)
                    to_row = row;
                end
            elseif (cell2mat(groups_array(row,col)) == first_crv)
                if (rem(col, 2) == 0)
                   from_row = row;
                end
            end
            
        end
    end
end