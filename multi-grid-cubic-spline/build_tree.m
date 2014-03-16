function [ multigridData ] = build_multigrid( hierInds, rawData)
%SPLINE_TREE Construct the tree using hierarchical index for spline
%   
% hierInds: [n-by-m] matrix, denoting m-level hierarchy. The first column
% contains indices at bottom level; the mth column contains indices for the
% highest hierarchy.
%
% Return data organized in multigrid format:
% [lvl-by-2] cell array.
% multigridData{n, 1} stores the data in the same format as rawData at nth
% level
% multigridData{n, 2} stores the child indices for each node at nth level
%
% Choice of anchor node: meta nodes that describe specified intervals with
% average (coarser scale approximation)
%

lvl = size(hierInds, 2);
multigridData = cell(lvl, 2);

% data size
n = size(hierInds, 1);
intervals = 1;

% Top-down: calculate indices
for depth = lvl: -1: 2
    for j = 1: length(intervals)
        iStart = intervals(j);
        if j == length(intervals)
            iEnd = n;
        else
            iEnd = intervals(j + 1) - 1;
        end
        [C, iHierInds, ~] = unique(hierInds(iStart: iEnd, depth));
        multigridData{lvl - depth + 1, 2} = [multigridData{depth, 2}; ...
            iHierInds + (iStart - 1)];
    end
    intervals = multigridData{lvl - depth + 1, 2};
end
% last lvl: the leaves
% allow repeated indices in the last level of hierInds indicating resampling
multigridData{lvl, 1} = rawData;

% bottom up: calculate anchor values (mean in the intervals)
for depth = lvl - 1: -1: 1
    inds = multigridData{depth, 2};
    for j = 1: length(inds)
        iStart = inds(j);
        if j == length(inds)
            iEnd = n;
        else
            iEnd = inds(j + 1) - 1;
        end
        multigridData{depth, 1}(j) = mean(rawData(iStart: iEnd));
    end
end

end

% --------------
% Rex Ying
% Undergraduate students at Duke CS 
% 03/14/2014
% ----------------
