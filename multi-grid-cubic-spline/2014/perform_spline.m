function [ ppcoeffs, xgrid ] = perform_spline( multigrid, xnodes, smoothParams )
%PERFORM_SPLINE Perform multigrid cubic spline
%
% multigrid: multigrid data
% xnodes: the bottom level data sampling location.
% smoothParams: smoothing parameters for each level of the spline. Default
%   is no smoothing (equivalent to smoothing parameter = 1.
%   If parameter = 0, it is a least square linear fit.
%
% ppcoeffs: each cell contains the piecewise polynomial coefficients to be used by ppval.
%   It is a n-cell array, the ith cell contains the piecewise polynomial form
%   at the ith scale. 
%   The first cell is the approximation spline, and the rest are details at 
%   different scales.
% xgrid: the position of anchor nodes. xgrid{i} contains the ith level anchor
%   nodes x-position.
%

if (nargin < 3)
    isSmooth = false;
else
    isSmooth = true;
end

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
xgrid{lvl} = xnodes;

if isSmooth
    ppcoeffs{1} = csaps(xgrid{1}, multigrid{1, 1}{1}, smoothParams(lvl));
else
    ppcoeffs{1} = spline(xgrid{1}, multigrid{1, 1}{1});
end

%% higher level

for iLevel = 2: lvl - 1
    % evaluate using upper level polynomial
    pEval = ppval(ppcoeffs{iLevel - 1}, xgrid{iLevel});
    % diffEval has the same length as pEval, or xgrid{lvl}
    diffEval = cell2mat(multigrid{iLevel, 1}) - pEval;
    %diffEval = cell2mat(multigrid{lvl, 1});
    nAnchors = length(xgrid{iLevel - 1});

    sampleInds = zeros(nAnchors, 1);
    for i = 1: nAnchors
        % this is approximated right now
        sampleInds(i) = binary_search(xgrid{iLevel}, xgrid{iLevel - 1}(i));
    end

    % first segment
    % startNode / endNode index xgrid{lvl}
    startNode = 1;
    endNode = sampleInds(1);
    x = xgrid{iLevel}(startNode: endNode);
    y = diffEval(startNode: endNode);
    % approximate gradient
    grad1 = der3pt(x(1: 3), y(1: 3), 'le');
    grad2 = der3pt(xnodes(endNode - 1: endNode + 1), diffEval(endNode - 1: endNode + 1));
    %if isSmooth
    %    sCoeffs = csaps(x, [grad1, y, grad2], smoothParams(lvl));
    %else
        sCoeffs = spline(x, [grad1, y, grad2]);
    %end
    % prepare for next iteration
    grad1 = grad2;
    startNode = endNode;

    % segments in between
    for i = 2: nAnchors + 1
        if i <= nAnchors
            endNode = sampleInds(i);
        else
            endNode = length(xgrid{iLevel});
            xgrid{iLevel}(startNode: endNode)
        end

        x = xgrid{iLevel}(startNode: endNode);
        y = diffEval(startNode: endNode);

        % calculate estimation of gradient
        % Right end of the segment
        if endNode <= nAnchors
            xLoc = xgrid{iLevel}(endNode - 1: endNode + 1);
            yLoc = diffEval(endNode - 1: endNode + 1);
            grad2 = der3pt(xLoc, yLoc);
        else
            xLoc = xgrid{iLevel}(endNode - 2: endNode);
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
    ppcoeffs{iLevel} = sCoeffs;
end

if isSmooth
    ppcoeffs{lvl} = csaps(xnodes, cell2mat(multigrid{lvl, 1}), smoothParams(lvl));
else
	ppcoeffs{lvl} = spline(xnodes, cell2mat(multigrid{lvl, 1}));
end


end

% --------------
% Rex Ying
% Undergraduate students at Duke CS 
% 03/17/2014
% ----------------