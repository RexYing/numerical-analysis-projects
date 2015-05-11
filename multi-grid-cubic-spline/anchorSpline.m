function [ pp ] = anchorSpline( xx, yy, anchors, bc )
%ANCHORSPLINE Perform adaptive spline based on a list of anchor sample
%points
%   Separate samples into k+1 segments, where k is the number of sample points.   
% Compute first and second derivatives on anchor points and perform local
% spline.
%
%   INPUT:
%   xx: [1-by-n] vector of sample position where n is the number of sample
%   points
%   yy: [1-by-n] vector of values corresponding to the values at position
%   xx
%   anchors: [1-by-k] vector of anchor sample position INDEX
%       in strictly increasing order. The anchor point does NOT include the
%       first and last sample points in xx.
%       All its values have to be between 1 and n (not inclusive)
%   bc: boundary condition. If bc is a [1-by-2] vector, it represents the
%   first derivatives at xx(1) and xx(end). If bc is empty, not-a-knot
%   condition will be applied.
%   
%   RETURN:
%   pps: [1-by-(k+1)] piecewise polynomials. Each element is a struct that
%   MATLAB uses for representing piecewise polynomials.
%

if iscolumn(xx)
    xx = xx';
end
if iscolumn(yy)
    yy = yy';
end

if (anchors(1) == 1) || (anchors(end) == length(xx))
    error('The anchor points should not include boundary points');
end

k = length(anchors);
% calculate derivatives at anchor points
% each row has  the 1st and 2nd derivatives of the corresponding anchor
% point
derivatives = zeros(k, 2);
for i = 1: k
    sample = xx((anchors(i) - 2) : (anchors(i) + 2));
    stencil = yy((anchors(i) - 2) : (anchors(i) + 2));
    derivatives(i, :)  = stencilDerivatives(sample, stencil);
end

% default clamped bc
sample = xx(1: anchors(1));

Y = [bc(1), yy(1: anchors(1)), derivatives(1, 1)];

pp = spline(sample, Y);
for i = 1: k-1
    sample = xx(anchors(i): anchors(i+1));
    Y = [derivatives(i, 1), yy(anchors(i): anchors(i+1)), derivatives(i+1, 1)];
    pp = combine_pp(pp, spline(sample, Y));
end
sample = xx(anchors(k): end);
Y = [derivatives(k, 1), yy(anchors(k): end), bc(2)];
pp = combine_pp(pp, spline(sample, Y));

for i = 1: k
    sample = xx(anchors(i) - 1: anchors(i) + 1);
    Y = yy(anchors(i) - 1: anchors(i) + 1);
    
    boundary = xx([anchors(i) - 1, anchors(i) + 1])';
    p1DerFn = fnder(pp, 1);
    p1Der = ppval(p1DerFn, boundary);
    p2DerFn = fnder(pp,2);
    p2Der = ppval(p2DerFn, boundary);
    der = [p1Der, p2Der];
    
    quarticCoefs = quarticSpline2(sample, Y, der);

    % modify pp

    if (pp.order == 4)
        pp.coefs = [zeros(pp.pieces, 1), pp.coefs];
        pp.order = 5;
    end
    pp.coefs(anchors(i) - 1, :) = quarticCoefs(5: -1: 1);
    pp.coefs(anchors(i), :) = quarticCoefs(10: -1: 6);
end

end

