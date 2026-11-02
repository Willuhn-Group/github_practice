% Groups of mice
close()

% Create the popup window
fig = uifigure('Name', 'Figureswindow');         % The figure itself
fig.Position = [300 300 1230 500];  % Figure position ([x, y, width, height])
ax = uiaxes(fig, 'Position', [5 50 400 400]);   % first graph position
ax.Title.String = 'Nosepokes per mouse';        % Title first graph
ax.XLabel.String = 'Tone onset (s)';            % Title X-axis
ax.YLabel.String = 'Nosepokes per second';      % Title Y-axis
ax.YLim = [0,1.5];               % Y-axis limits
first_colour = 'black';
second_colour = 'red';

% Positions of the other graphs in the pop-up window
ax2 = uiaxes(fig, 'Position', [405 50 400 400]);
ax3 = uiaxes(fig, 'Position', [805 50 400 400]);

% Define the X-variable for the graphs (6second timepoints)
x = ((-pre_onset + 6):6:post_onset);

% ==============================-0-================================= %

% create the first graph
hold(ax, 'on')
for i = 1:length(finalmousetable)
    y = finalmousetable{i,2};
    y = reshape(y,[1,25]);          % Formatting to correct format
    y = y / 6;                      % intervals of 6 seconds

    % WT mice will be black, KO mice will be red
    if strcmpi(finalmousetable{i,3}, 'WT')      % if wildtype then plot line first colour
        wtplot = plot(ax,x,y,first_colour);
        plot(ax, wtplot)
    else                                        % if other (knockout) plot line second colour
        koplot = plot(ax,x,y,second_colour);
        plot(ax, koplot);
    end
end

% legend
legend([wtplot, koplot], 'WT', 'KO')
close()

hold(ax, 'off')

% ==============================-O-================================ %

% genotype
ax2.Title.String = 'Mean nosepokes per condition';  % Title of the graph
ax2.XLabel.String = 'Tone onset (s)';               % Title of the X-axis
ax2.YLabel.String = 'Mean nosepokes per second';    % Title of the Y-axis
ax2.YLim = [0,1.5];         % Limit of the Y-axis

% create the second graph
hold(ax2, 'on')     % Hold so both lines will be on the same graph
[genotype1, genotype2] = meanplot(finalmousetable, individual_mouse_table, 3, 'WT');

% plot the first line
conditionplot_one = plot(ax2,x,genotype1,first_colour);
plot(ax2,conditionplot_one)

% plot the second line
conditionplot_two = plot(ax2,x,genotype2,second_colour);
plot(ax2,conditionplot_two)

% function for error areas
errorarea(x,ax2,genotype1,genotype2)

% add a fitting legend to the conditions
legend([conditionplot_one, conditionplot_two], 'WT', 'KO')


% ==============================-O-================================ %

% sex differences
hold(ax3, 'on')         % hold so both lines will be in the same graph
ax3.Title.String = 'Nosepokes per sex';     % Title of the graph
ax3.XLabel.String = 'Tone onset (s)';       % Name of the X-axis
ax3.YLabel.String = ' Mean nosepokes per second';   % Name of the Y-axis
ax3.YLim = [0,1.5];       % Limits of the Y-axis

% call the function that gets the data for the specific groups
hold(ax3, 'on')
[sex1, sex2] = meanplot(finalmousetable, individual_mouse_table, 4, 'F');

% plot the first line
sexplot_one = plot(ax3,x,sex1,first_colour);
plot(ax3,sexplot_one)

% plot the second line
sexplot_two = plot(ax3,x,sex2,second_colour);
plot(ax3,sexplot_two)

% function for error areas
errorarea(x,ax3,sex1,sex2)

% add a fitting legend
legend([sexplot_one, sexplot_two], 'Female', 'Male')