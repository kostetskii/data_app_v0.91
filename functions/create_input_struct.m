function [xdata ydata] = create_input_struct(crv_1, crv_end, not_this_crv, input_csv, x_ax_shift, x_col_num, crv_col, y_col_num, min_len, x_div_by);

    ydata = [];
    xdata = [];
    
    for curr_crv=crv_1:crv_end
        if ~(curr_crv == not_this_crv)
            cur_curve_indx = find(input_csv(:,crv_col) == curr_crv);
            
            if (curr_crv == crv_1)
                xdata = input_csv(cur_curve_indx(1:min_len),x_col_num)/x_div_by;
            end
            
            if (x_ax_shift > 0)
                x_shifted = xdata(:) - x_ax_shift;
                [~, off_p_indx]= min(abs(x_shifted));
                off_val = input_csv(cur_curve_indx(off_p_indx),y_col_num);
            else
                off_val = 0;
            end
            
            curr_y = input_csv(cur_curve_indx(:),y_col_num) - off_val;
            ydata = [ydata curr_y(1:min_len)];
        end
    end

end