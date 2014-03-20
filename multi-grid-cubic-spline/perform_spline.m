function [ ppcoeffs ] = perform_spline( multigrid, xnodes )
%PERFORM_SPLINE Perform multigrid cubic spline
%
% multigrid: multigrid data
% xnodes: the bottom level data sampling location.
% ppcoeffs: each cell contains the piecewise polynomial coefficients to be used by ppval.
%   It is a n-cell array, the ith cell contains the piecewise polynomial form
%   at the ith scale. 
%   The first cell is the approximation spline, and the rest are details at 
%   different scales.
%

lvl = size(multigrid, 1);
ppcoeffs = cell(lvl, 1);

% Get the position of the anchor nodes from 1 to lvl-1 levels
xgrid = cell(lvl - 1, 1);
groupInds = diff([0, multigrid{lvl, 2}]);
for i = lvl - 1: -1: 1
    nChNext = diff([0,  multigrid{i, 2}]);
    xgrid{i} = cellfun(@mean, mat2cell(xnodes, 1, groupInds));
    
    groups = mat2cell(groupInds, 1, nChNext);
    groupInds = cellfun(@sum, groups);
end

x = xgrid{1}
ppcoeffs{1} = spline(x, multigrid{1, 1}{1});

end

% --------------
% Rex Ying
% Undergraduate students at Duke CS 
% 03/17/2014
% ----------------