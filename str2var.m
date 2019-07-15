% FUNCTION VAR = STR2VAR(STR)
%
%  Returns the variable or array of variables, VAR, matching the 
%  pattern STR. Matching variables must be of same type.
%
%   a = 3;
%   b = str2var('a'); % b is now equal to a, i.e. 3.
%
%   a1 = 3;
%   a2 = 2;
%   b = str2var('a*'); % b is now an array with values [3, 2].
%

function var = str2var(str)

var_list = evalin('caller', ['whos(''', str, ''')']);
[var_names{1:length(var_list)}] = deal(var_list(:).name);
var_names(2,:) = {','};
var_names(2,end) = {''};
var = evalin('caller', ['[', sprintf('%s', var_names{:}), ']']);
