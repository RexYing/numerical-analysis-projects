function [ pos ] = binary_search( arr, val )
%BINARY_SEARCH binary search a sorted array
%
% return: the position where val should be inserted in arr.
%   When there is no element in arr equal to val, return the index where
%   val can be inserted

left = 1;
right = length(arr) + 1;
pos = 0;
while left < right
    mid = bitshift((left + right), -1);
    if val > arr(mid)
        left = mid + 1;
    elseif val < arr(mid)
        right = mid;
    else
        pos = mid;
        break;
    end
end
% no element equal to val is found in arr
if pos == 0
    if left ~= right
        disp('wth?');
    end
    pos = left;
end

end

% --------------
% Rex Ying
% Undergraduate students at Duke CS 
% 03/16/2014
% ----------------
