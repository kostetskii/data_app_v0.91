function [sigma, av_y, x_point_indx] = get_stat(data_ex, x_points, accur)

    len_x = length(x_points);
    data_in_cols_len = length(data_ex(1, :));
    entries = data_in_cols_len-1;
    
    sigma = zeros(1, len_x);
    x_point_indx = zeros(1, len_x);
    sum = zeros(1, len_x);
    s_sum = zeros(1, len_x);
	av_y = zeros(1, len_x);

    
    try
        for i=1:len_x
            x = find(round(x_points(i), accur) == round(data_ex(:, 1), accur));
            x_point_indx(i) = x(1);
        end
        clear i
    catch
        warning('NO MATCHING POINTS, CHECK TIME ARR AND ACCURACY OF DATA WHILE COMPARING')
        return
    end
    
    for i=1:len_x
        for k=1:entries
            sum(i) = sum(i) + data_ex(x_point_indx(i), k+1);
            if (k == entries)
                av_y(i) = sum(i)/entries;
            end
        end
    end
    clear i k
    
    for i=1:len_x
        for k=1:entries
            s_sum(i) = s_sum(i) + power((data_ex(x_point_indx(i), k+1)-av_y(i)),2);
        end
    end
    clear i k
    
    for i=1:len_x
        sigma(i) = power((1/(entries+1)*s_sum(i)), 1/2);
    end
end