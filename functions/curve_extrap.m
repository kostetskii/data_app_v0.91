function [x, y] = curve_extrap(x_in, y_in, x_to, type, offset, low_mem)
    
    x_out = x_in(1+offset:end);
    y_out = y_in(1+offset:end);
    
    p1 = polyfit(x_out, y_out, 1);
    x_out = ([(x_out)' x_out(length(x_out)):0.1:x_to]);
    y_out = polyval(p1, x_out);
    
    if low_mem
        x_to_plot = [x_out(1) x_out(end)];
        y_to_plot = [y_out(1) y_out(end)];
    else
        x_to_plot = x_out;
        y_to_plot = y_out;
    end
    
    thickness = 1;
    plot(x_to_plot, y_to_plot, type, 'linewidth', thickness);
    hold on
    set(gca, 'XScale', 'linear');
    
    x = x_out';
    y = y_out';
end