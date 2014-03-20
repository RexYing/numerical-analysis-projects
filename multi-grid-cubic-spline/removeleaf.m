function [ multigrid ] = removeleaf( multigrid, index, update )
%REMOVELEAF Remove a leaf node in multigrid
%   
% multigrid: data in the form of a multigrid tree, produced by build_tree.m
% index: a vector indicating the index of the data being added. The length
%   of the vector is equal to the levels of the multigrid.
%   Order: from lowest level to highest level.

lvl = size(multigrid, 1);

if (nargin < 3)
    update = true;
end
%% locate in multigrid with index

% stores its index at different levels of multigrid
hierInds = zeros(lvl, 1);
% the set of children it belongs to on the next level
groupInd = 1;
for depth = 1: lvl
    if groupInd == 1
        iStart = 1;
    else
        iStart = multigrid{depth, 2}(groupInd - 1) + 1;
    end
    iEnd = multigrid{depth, 2}(groupInd);
    % search for the position to insert
    ind = binary_search(multigrid{depth, 3}(iStart: iEnd), index(lvl - depth + 1));
    groupInd = iStart - 1 + ind;
    hierInds(depth) = groupInd;
    % has to be exact match
    if multigrid{depth, 3}(groupInd) ~= index(lvl - depth + 1)
        warning('removeleaf: Index does not exist in multigrid. Did not remove anything');
        return;
    end
end

%% remove the element and update if necessary
parentInd = hierInds(lvl - 1);

multigrid{lvl, 3} = [multigrid{lvl, 3}(1: groupInd - 1), ...
    multigrid{lvl, 3}(groupInd + 1: end)];
multigrid{lvl, 2}(parentInd: end) = multigrid{lvl, 2}(parentInd: end) - 1;
if parentInd == 1
    localInd = groupInd;
else
    localInd = groupInd - multigrid{lvl, 2}(parentInd - 1);
end

multigrid{lvl, 1}{parentInd} = [multigrid{lvl, 1}{parentInd}(1: localInd - 1), ...
    multigrid{lvl, 1}{parentInd}(localInd + 1: end)];
% also update higher levels
if update
    for i = lvl - 1: -1: 2
        if hierInds(i - 1) == 1
            localInd = hierInds(i);
        else
            localInd = hierInds(i) - multigrid{lvl, 2}(hierInds(i - 1) - 1);
        end
        multigrid{i, 1}{hierInds(i - 1)}(localInd) = mean(multigrid{i + 1, 1}{hierInds(i)});
    end
    % top lvl
    multigrid{1, 1}{1}(hierInds(1)) = mean(multigrid{2, 1}{hierInds(1)});
end

end

% --------------
% Rex Ying
% Undergraduate students at Duke CS 
% 03/16/2014
% ----------------