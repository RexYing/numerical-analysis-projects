function [ pps ] = anchorSpline( xx, yy, anchors, bc )
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
%   anchors: [1-by-k] vector of anchor sample position (must be a subset of
%   xx) in strictly increasing order. The anchor point does not include the
%   first and last sample points in xx.
%   bc: boundary condition. If bc is a [1-by-2] vector, it represents the
%   first derivatives at xx(1) and xx(end). If bc is empty, not-a-knot
%   condition will be applied.
%   
%   RETURN:
%   pps: [1-by-(k+1)] piecewise polynomials. Each element is a struct that
%   MATLAB uses for representing piecewise polynomials.
%

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

for i = 1: k-1
    s = anchors(i);
    e = anchors(i + 1);
    if i == 1
        pps = spapi(augknt(s: e, 5), [xx(s: e), s, s, e, e], ...
            [yy(s: e), derivatives(i, 1), derivatives(i, 2), derivatives(i+1, 1), derivatives(i+1, 2)]);
    end
end

if length(bc) == 2 % clamped condition
    
end

end

