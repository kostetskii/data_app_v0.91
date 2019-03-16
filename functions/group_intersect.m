function [intersect_max, intersect_min] = group_intersect(x_point, x_data, y_data, accur)
    try
        x_indx = find(round(x_data(:), accur) == round(x_point, accur));
        indx = x_indx(1);
        y_in_point = y_data(indx,:);
        [intersect_max,~] = max(y_in_point);
        [intersect_min,~] = min(y_in_point);
    catch
        warning('NO MATCHING POINTS, CHECK TIME ARR AND ACCURACY OF DATA WHILE COMPARING')
        return
    end
end