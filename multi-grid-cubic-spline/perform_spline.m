function [ ppcoeffs, xgrid ] = perform_spline( multigrid, xnodes )
%PERFORM_SPLINE Perform multigrid cubic spline
%
% multigrid: multigrid data
% xnodes: the bottom level data sampling location.
%
% ppcoeffs: each cell contains the piecewise polynomial coefficients to be used by ppval.
%   It is a n-cell array, the ith cell contains the piecewise polynomial form
%   at the ith scale. 
%   The first cell is the approximation spline, and the rest are details at 
%   different scales.
% xgrid: the position of anchor nodes. xgrid{i} contains the ith level anchor
%   nodes x-position.
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

ppcoeffs{1} = spline(xgrid{1}, multigrid{1, 1}{1});

%% higher level

lvl = 2;
% evaluate using upper level polynomial
pEval = ppval(ppcoeffs{lvl - 1}, xgrid{lvl});
% diffEval has the same length as pEval, or xgrid{lvl}
diffEval = cell2mat(multigrid{lvl, 1}) - pEval;
%diffEval = cell2mat(multigrid{lvl, 1});
nAnchors = length(xgrid{lvl - 1});

sampleInds = zeros(nAnchors, 1);
for i = 1: nAnchors
    % this is approximated right now
    sampleInds(i) = binary_search(xgrid{lvl}, xgrid{lvl - 1}(i));
end

% first segment
% startNode / endNode index xgrid{lvl}
startNode = 1;
endNode = sampleInds(1);
x = xgrid{lvl}(startNode: endNode);
y = diffEval(startNode: endNode);
% approximate gradient
grad1 = der3pt(x(1: 3), y(1: 3), 'le');
grad2 = der3pt(xnodes(endNode - 1: endNode + 1), diffEval(endNode - 1: endNode + 1));
sCoeffs = spline(x, [grad1, y, grad2]);
% prepare for next iteration
grad1 = grad2;
startNode = endNode;

% segments in between
for i = 2: nAnchors + 1
    if i <= nAnchors
        endNode = sampleInds(i);
    else
        endNode = length(xgrid{lvl});
        xgrid{lvl}(startNode: endNode)
    end
        
    x = xgrid{lvl}(startNode: endNode);
    y = diffEval(startNode: endNode);
    
    % calculate estimation of gradient
    % Right end of the segment
    if endNode <= nAnchors
        xLoc = xgrid{lvl}(endNode - 1: endNode + 1);
        yLoc = diffEval(endNode - 1: endNode + 1);
        grad2 = der3pt(xLoc, yLoc);
    else
        xLoc = xgrid{lvl}(endNode - 2: endNode);
        yLoc = diffEval(endNode - 2: endNode);
        grad2 = der3pt(xLoc, yLoc, 're');
    end
    % estimated boundary condition for sub-level spline
    sCoeffsTmp = spline(x, [grad1, y, grad2]);
    sCoeffs = combine_pp(sCoeffs, sCoeffsTmp);
    
    grad1 = grad2;
    startNode = endNode;
end

%ppcoeffs{2} = spline(xgrid{2}, cell2mat(multigrid{2, 1}));
% add the spline function of the first level.
sCoeffs = add_pp(sCoeffs, ppcoeffs{1});
ppcoeffs{2} = sCoeffs;
ppcoeffs{3} = spline(xnodes, cell2mat(multigrid{3, 1}));

end

% --------------
% Rex Ying
% Undergraduate students at Duke CS 
% 03/17/2014
% ----------------