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
% multigridData{n, 3} stores the index information provided by hierInds
%
% Choice of anchor node: meta nodes that describe specified intervals with
% average (coarser scale approximation)
%

lvl = size(hierInds, 2);
multigridData = cell(lvl, 3);

% data size
n = size(hierInds, 1);
% interval is decided by the same values in the coarser level
intervals = 1;

multigridData{1} = cell(1, 1);
% Top-down: calculate space for each level and preallocate
% also records the non-leaf indices
for depth = 1: lvl
    nextIntervals = zeros(n, 1);
    sizeNextInterv = 0; 
    nChild = zeros(length(multigridData{depth, 1}), 1);
    i = 1;
    for j = 1: length(intervals)
        iStart = intervals(j);
        if j == length(intervals)
            iEnd = n;
        else
            iEnd = intervals(j + 1) - 1;
        end
        [C, iHierInds, ~] = unique(hierInds(iStart: iEnd, lvl - depth + 1), 'first');
        
        multigridData{depth, 3} = [multigridData{depth, 3}, C'];
        % number of children in each interval at current level
        nChild(j) = length(C);
        nextIntervals(sizeNextInterv + 1: sizeNextInterv + length(C)) ...
            = iHierInds + (iStart - 1);
        sizeNextInterv = sizeNextInterv + length(C);
        i = i + 1;
    end
    if (depth ~= lvl)
        multigridData{depth + 1, 1} = cell(1, sizeNextInterv);
        intervals = nextIntervals(1: sizeNextInterv);
    end
    multigridData{depth, 2} = nChild';
end

% last lvl: the leaves
% allow repeated indices in the last level of hierInds indicating resampling
multigridData{lvl, 1} = mat2cell(rawData', 1, multigridData{lvl, 2});
multigridData{depth, 2} = cumsum(multigridData{depth, 2});

% bottom up: calculate anchor values (mean in the intervals)
for depth = lvl - 1: -1: 1
    % unify the children indices across the entire level
    multigridData{depth, 2} = cumsum(multigridData{depth, 2});
    inds = multigridData{depth, 2};
    iStart = 1;
    for j = 1: length(inds)
        iEnd = inds(j);
        % Averages of the data in the next finer level taken as the values
        % of the current level
        multigridData{depth, 1}{j} = cellfun(@mean, multigridData{depth + 1, 1}(iStart: iEnd));
        iStart = iEnd + 1;
    end
end

end

% --------------
% Rex Ying
% Undergraduate students at Duke CS 
% 03/14/2014
% ----------------
