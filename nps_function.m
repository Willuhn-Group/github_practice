function [mousedata] = nps_function(rows,mouse_array,pretone_length,posttone_length)
% nps_function takes the data for a condition for each defined mouse and
% looks for the events in a specified interval of time
%   Input:
%   - rows = all rows you are interested in (struct). Also see "getRows" function
%   - mouse_array = array with the name of each mouse of interest
%   - pretone_length = number of seconds of interest pre-tone onset
%   - posttone_length = number of seconds of interest post-tone onset


% calculate the amount of timepoints
seconds = (pretone_length + posttone_length) / 6; % 6 seconds interval between each timepoint

% The big graph with all the information
mousedata = zeros(seconds,length(mouse_array));

% Loop to go over each mouse
for current_mouse = 1:length(mouse_array)

    % Filter the big table to get only rows of the current mouse
    mymouse = mouse_array(current_mouse);
    mouserow = getRows(rows,"mouse",mymouse);

    % Make the array for the individual mouse data
    trial_array = zeros(seconds,length(mouserow.box));

    % loop to get the nosepoke events in specific intervals for each session
    for a = 1:length(mouserow.event_mat)

        % Find the tone onset timepoints
        onset = [find(mouserow.event_mat{a}(1,:) == 10)];
        timepoints = [mouserow.event_mat{a}(2,onset)];
        nosepokes = [find(mouserow.event_mat{a}(1,:) == 8)];

        % check each time point for each registered nosepoke
        for i = 1:length(nosepokes)
            % the following loop is repeated for nosepoke amount of times
            for j = 1:length(timepoints)

                % define intervals (6000 = 1 minute)
                first_interval = 6000;
                second_interval = 5400;

                % For each interval get the data
                for intervals = 1:seconds

                    % For each point, if it falls within the interval it is
                    % saved and counted
                    if mouserow.event_mat{a}(2,nosepokes(i)) > timepoints(j) - first_interval ...
                            && mouserow.event_mat{a}(2,nosepokes(i)) < timepoints(j) - second_interval
                        trial_array(intervals,a) = trial_array(intervals,a) + 1;
                    end

                    % lower interval for new 6 seconds
                    first_interval = first_interval - 600;
                    second_interval = second_interval - 600;

                end

            end
        end
    end
    % For each 6 seconds, add the mean nosepokes to the big dataframe
    for current_timepoint = 1:seconds
        mousedata(current_timepoint,current_mouse) = mean(trial_array(current_timepoint,:));
    end

    % this is repeated for each mouse
end
end