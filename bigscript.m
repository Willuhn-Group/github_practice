%% data indexed to right table
load("all_cohorts_25-Nov-2025.mat")
tab = struct2table(bigstruct.all_sess);
rows = getRows(tab,"stage","PMA");      % primary table with all info about PMA

% list the unique mice
mouse_array = [unique(rows.mouse)];     % gives array with each mouse name

% index the genotype
genotype = getRows(tab,"genotype","KO");
knockout = unique(genotype.mouse);

% index the sex
sex = getRows(tab,"sex","F");
females = unique(sex.mouse);

%% -----------------------Get nosepokes per second------------------------

% define the variables for the function iterating over all data in "rows"
task_data = rows;
mice = mouse_array;
pre_onset = 60;     % 60 seconds before
post_onset = 90;    % 90 seconds after (30 + 60)

% run the function
individual_mouse_table = nps_function(task_data,mice,pre_onset,post_onset);


%% ------------------------Make the big table--------------------------
for i = 1:length(mouse_array)
    % Mouse
    finalmousetable(i,1) = mouse_array(i);

    % Nosepokes / sec for each timepoint
    finalmousetable(i,2) = {individual_mouse_table(:,i) / 6};

    % genotype
    if ismember(mouse_array(i), knockout)
        finalmousetable(i,3) = {'WT'};
    else
        finalmousetable(i,3) = {'KO'};
    end

    % sex
    if ismember(mouse_array(i), females)
        finalmousetable(i,4) = {'F'};
    else
        finalmousetable(i,4) = {'M'};
    end
end