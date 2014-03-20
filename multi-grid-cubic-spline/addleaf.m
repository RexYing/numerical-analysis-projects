function [ multigrid ] = addleaf( multigrid, index, data )
%ADDLEAF Add a data entry. Its ancestors are determined by the index.
%   
% multigrid: data in the form of a multigrid tree, produced by build_tree.m
% index: a vector indicating the index of the data being added. The length
%   of the vector is equal to the levels of the multigrid.
%   Order: from lowest level to highest level.
% data: one or an array of data, which have to be consistent with the data
% type of the multigrid.
%

lvl = size(multigrid, 1);

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
    % has to be exact match except at the last level
    if depth ~= lvl && multigrid{depth, 3}(groupInd) ~= index(lvl - depth + 1)
        warning('addleaf: Index does not exist in multigrid. Did not remove anything');
        return;
    end
end

% If no new anchor nodes necessary, just insert at the bottom level
parentInd = hierInds(lvl - 1);

multigrid{lvl, 3} = [multigrid{lvl, 3}(1: groupInd - 1), index(1), ...
    multigrid{lvl, 3}(groupInd: end)];
multigrid{lvl, 2}(parentInd: end) = multigrid{lvl, 2}(parentInd: end) + 1;
if parentInd == 1
    localInd = groupInd;
else
    localInd = groupInd - multigrid{lvl, 2}(parentInd - 1);
end
multigrid{lvl, 1}{parentInd} = [multigrid{lvl, 1}{parentInd}(1: localInd - 1), ...
    data, multigrid{lvl, 1}{parentInd}(localInd: end)];

end

% --------------
% Rex Ying
% Undergraduate students at Duke CS 
% 03/16/2014
% ----------------