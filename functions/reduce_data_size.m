function [data_out_x, data_out_y, rem_points] = reduce_data_size(data_in_x, data_in_y, round_to)

    if nargin < 3
        round_to = 4;
    end
    
	data_len = length(data_in_x);
	rem_points = 0;
    data_out_x = [];
    data_out_y = [];
    next_needed = 1;
    
	for i=1:data_len
        if next_needed
            data_out_x = [data_out_x; data_in_x(i)];
            data_out_y = [data_out_y; data_in_y(i)];
        end
        
        if (i <= (data_len-2))
            dy21 = data_in_y(i+1)-data_in_y(i);
            dy31 = data_in_y(i+2)-data_in_y(i);
        
            dx21 = data_in_x(i+1)-data_in_x(i);
            dx31 = data_in_x(i+2)-data_in_x(i);
        
            slope21 = round(dy21/dx21, round_to);
            slope31 = round(dy31/dx31, round_to);
        
            if (slope21 == slope31)
                rem_points = rem_points+1;
                next_needed = 0;
            else
                next_needed = 1;
            end
        end
    end
end