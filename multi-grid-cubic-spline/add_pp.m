function [ pp ] = add_pp( pp1, pp2, range )
%ADD_PP add piecewise polynomial
%
% Range: if range is set to 'common', the common range is taken when the 
% two piecewise polynomials are not of the same range. (there will
% be extrapolation outside of the common range).
%   Otherwise, the entire range is taken.
%
% 

if nargin >= 3 && strcmp(range, 'common')
    commonRange = true;
else
    % By default, the entire range is taken.
    commonRange = false;
end
    

pp = pp1;

%% Find common range
breaks1 = pp1.breaks;
breaks2 = pp2.breaks;
coefs1 = pp1.coefs;
coefs2 = pp2.coefs;
if commonRange
    % beginning
    if breaks1(1) < breaks2(1)
        i = 2;
        while breaks1(i) < breaks2(1)
            i = i + 1;
        end
        breaks1 = breaks1(i: end);
        coefs1 = coefs1(i: end, :);
    elseif breaks2(1) < breaks1(1)
        i = 2;
        while breaks2(i) < breaks1(1)
            i = i + 1;
        end
        breaks2 = breaks2(i: end);
        coefs2 = coefs2(i: end, :);
    end
    % end
    if breaks1(end) > breaks2(end)
        i = length(breaks1) - 1;
        while breaks1(i) > breaks2(end)
            i = i - 1;
        end
        breaks1 = breaks1(1: i);
        coefs1 = coefs1(1: i, :);
    elseif breaks2(end) > breaks1(end)
        i = length(breaks2) - 1;
        while breaks2(i) > breaks1(end)
            i = i - 1;
        end
        breaks2 = breaks2(1: i);
        coefs2 = coefs2(1: i, :);
    end
end

%% Reconstruct
% third argument 1: for spline
pp1 = ppmak(breaks1, coefs1, 1);
pp2 = ppmak(breaks2, coefs2, 1);

%% Merge breaks
% breaks = zeros(length(breaks1) + length(breaks2), 1);
% count = 0;
% i = 1;
% j = 1;
% 
% while i <= length(breaks1) || j <= length(breaks2)
%     if i <= length(breaks1) && (j > length(breaks2) || breaks1(i) < breaks2(j))
%         if count > 0 && breaks(count) == breaks1(i)
%             i = i + 1;
%             continue;
%         end
%         % new break
%         count = count + 1;
%         breaks(count) = breaks1(i);
%         i = i + 1;
%     else
%         if count > 0 && breaks(count) == breaks2(j)
%             j = j + 1;
%             continue;
%         end
%         count = count + 1;
%         breaks(count) = breaks2(j);
%         j = j + 1;
%     end
% end
% breaks = breaks(1: count);
% 
% fnbrk(pp1, [2, 3])
% 
% pp.breaks = breaks;
%pp = fncmb(pp1, pp2)

pp1 = fnrfn(pp1, setdiff(pp2.breaks, pp1.breaks));
pp2 = fnrfn(pp2, setdiff(pp1.breaks, pp2.breaks));
pp = fncmb(pp1, pp2);

end

% --------------
% Rex Ying
% Undergraduate students at Duke CS 
% 04/05/2014
% ----------------