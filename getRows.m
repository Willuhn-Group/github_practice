%% rowgetting
function rows = getRows(mytable, columnname, values)
% getRows - Returns rows from a table where a given column matches values
% rows = getRows(mytable, columnname, values)
%   mytable    = table name
%   columnname = STR or CHAR
%   values     = "column specification", can be plural ["...","..."]

    % column
    column = mytable.(columnname);

    % Ensure values is a column vector for matching
    values = values(:);

    mask = ismember(column, values);

    % Return matching rows
    rows = mytable(mask, :);
    
end
