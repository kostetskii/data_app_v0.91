function [] = new_fig(xname, yname, x_point, y_point, plot_title)

    fig = figure();
    hold on
    xlabel(xname);
    ylabel(yname);
    title(plot_title);
    axis([x_point y_point]);
    
end