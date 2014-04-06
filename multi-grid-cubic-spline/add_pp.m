function [ pp ] = add_pp( pp1, pp2 )
%ADD_PP add piecewise polynomial
%   
% 

pp = pp1;

% merge breaks
breaks = zeros(max(length(pp1), length(pp2)));
count = 0;
lastVal = [];
i = 1;
j = 1;
while i < length(pp1.breaks) || j < length(pp2.breaks)
    next = min(pp1.breaks(i), pp2.breaks(j));
    if pp1.breaks(i) ~= breaks(count)
        % new break
        count = count + 1;
        breaks(count) = pp1.breaks(i);
        pp2.breaks(j) ~= breaks(count)

    breaks(count);
    

end

% --------------
% Rex Ying
% Undergraduate students at Duke CS 
% 04/05/2014
% ----------------