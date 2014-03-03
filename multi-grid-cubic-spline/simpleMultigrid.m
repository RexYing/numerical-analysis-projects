%% simpleMultigrid.m 
% 
% Purpose : 
% Multi-grid cubic spline: choose sqrt(n) of sample points as anchors and
% perform cubic spline on these points, and then for each interval between
% two anchors, perform another round of cubic spline.
%
% This is a very simple 1-D implementation of multi-grid cubic spline for 
% equally spaced samples just to illustrate the concept. Only two levels of
% spline are possible.
% 
% Dependency : 
% spline  (built-in) 
% ppval   (built-in) 
% maxihat (built-in)
% runge   (provided) 
% 

clear all ; 
close all 


fprintf( '\n\n Multigrid cubic spline started \n');
fprintf( '\n Choose from the following functions: \n');
fprintf('\n  1: Runge \n');
fprintf('\n  2: Maxican hat (scaled) \n');

% Runge performs better with boundary condition y' = y'' = 0
% Maxican hat performs better with boundary y'(lb) = y'(ub) = 0
sType = 2;

% number of grid points
n = 181;
% ratio
r = 10;
% number of interpolant
nInter = r * (n - 1) + 1;

%% interpolation nodes and evaluation nodes

funNum = input('\n\n  Please enter the function number:  ');

% lower bound and upper bound for functions
lb = -1;
ub = 1;

xnodes = linspace(lb, ub, n)';         % equi-spaced sampling
xEval = linspace(lb, ub, nInter)' ;   % make an odd # to show the midpoint
if funNum == 1
    funName = 'Runge';
    ynodes = runge(xnodes);
    fEval = runge(xEval);
    yprime = 50/26^2;    % end slopes of Runge for the clamped spline
elseif funNum == 2
    funName = 'Maxican hat';
    % effective support for the function: [-5, 5]
    [ynodes, ~] = mexihat(-5, 5, n);
    ynodes = ynodes';
    [fEval, ~] = mexihat(-5, 5, nInter);
    fEval = fEval';
    yprime = 0;
end


%% Start spline (first step)

% Choose square root to make the size of sample points for each spline
% roughly equal.
nAnchors = floor(sqrt(n));
if nAnchors <= 2
	disp('The number of sample points is set too small to demonstrate multi-grid properly');
    return;
end

% params for cubic spline
x = [xnodes(1: nAnchors: n); xnodes(end)];
y = [ynodes(1: nAnchors: n); ynodes(end)];

switch sType
    case 1
        % evaluate at n sample locations (for the second round of spline)
        % not-a-knot condition
        pEval = spline(x, y, xnodes);
    case 2
        %yprime = 0 ;         % for "natural" spline  
        sCoefs = spline(x, [yprime; y; -yprime]);
        pEval = ppval(sCoefs, xnodes);
        pEvalAll = ppval(sCoefs, xEval);
    otherwise 
        error(' unknown spline type ');
end

    
%% display the interpolation errs at the evaluation points 

figure(1);

%  plot( Xeval, FatXeval, 'b.');
plot(xnodes(1: nAnchors: n), ynodes(1: nAnchors: n), 'k.', 'MarkerSize', 5);
hold on 
plot(xEval, fEval, 'b.', 'MarkerSize', 4);
plot(xnodes, pEval, 'm.', 'MarkerSize', 5);
legend('Sample points', funName, 'Spline interpolant', 'Location', 'Best');
hold off 

xlabel('x');
bannerStr = sprintf( 'Spline interpolation with # sample %d ', n); 
title( bannerStr ); 

fprintf( '\n\n  First step finished \n\n ');

%% Second step

diffEval = ynodes - pEval;
pEval = zeros(nInter, 1);
ind = 1;
sampleInd = 1;
for i = 1: length(x) - 2
    x = xnodes(sampleInd: sampleInd + nAnchors);
    y = diffEval(sampleInd: sampleInd + nAnchors);
    xx = linspace(xnodes(sampleInd), xnodes(sampleInd + nAnchors), r * nAnchors + 1);
    sampleInd = sampleInd + nAnchors;
    
    % calculate estimation of gradient
    grad1 = (y(2) - y(1)) / (x(2) - x(1));
    grad2 = (y(end) - y(end - 1)) / (x(end) - x(end - 1));
%     xLoc = [xnodes(sampleInd - 1: sampleInd + 1)];
%     yLoc = [ynodes(sampleInd - 1: sampleInd + 1)];
    % estimated boundary condition for sub-level spline
    sCoefs = spline(x, [0; y; 0]);
    segEval = ppval(sCoefs, xx);
    pEval(ind: ind + length(segEval) - 1) = segEval';
    ind = ind + length(segEval) - 1;
end
% last segment
x = xnodes(sampleInd: end);
y = diffEval(sampleInd: end);
xx = linspace(xnodes(sampleInd), xnodes(end), r * (length(xnodes) - sampleInd) + 1);

sCoefs = spline(x, [0; y; 0]);
segEval = ppval(sCoefs, xx);
pEval(ind: end) = segEval';

pEval = pEval + pEvalAll;

%% error evaluation 

% sup norm
errFitSup  = eps + norm(fEval - pEval, 'inf'); 
% L2 norm
errFit2 = eps + norm(fEval - pEval, 2) / sqrt(n);  % with n-scaling  

fprintf( '\n  ErrInf = %0.3g', errFitSup ); 
fprintf( '\n  Err2   = %0.3g', errFit2 );

%% display the interpolation errs at the evaluation points 

figure(2);

plot(xEval, fEval, 'b.', 'MarkerSize', 4);
hold on;
plot(xEval, pEval, 'm.', 'MarkerSize', 4);
legend(funName, 'Spline interpolant', 'Location', 'Best');
hold off;

xlabel('x');
bannerStr = sprintf( 'Spline interpolation with # sample %d ', n); 
title( bannerStr ); 

fprintf( '\n\n  Second step finished \n\n ');

return 

% --------------
% Rex Ying
% Undergraduate students at Duke CS 
% 02/28/2014
% ----------------
