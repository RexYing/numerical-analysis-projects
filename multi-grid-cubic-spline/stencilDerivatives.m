function [ pp, der ] = stencilDerivatives( sample, stencil )
%STENCILDERIVATIVES Given a 5-point stencil, calculate the first and second
%derivatives of the anchor point
% If the stencil has values [y1, y2, y3, y4, y5] at [x1, x2, x3, x4, x5],
% the function values in intervals [x1, x2], [x4, x5] are
% approximated by linear function and [y2, y3] and [y3, y4] are approximated
% by cubic polynomial.
%
%   INPUT:
%   sample: [1-by-5] vector of sample position where anchor point is
%   positioned at the middle
%   stencil: [1-by-5] vector of function values at sample points 
%   
%   RETURN:
%   der: [1-by-2] vector of first and second derivatives
%

% 1st derivative approx at x2, x4
Y = [(stencil(2) - stencil(1)) / (sample(2) - sample(1)), stencil(2: 4), ...
    (stencil(5) - stencil(4)) / (sample(5) - sample(4))];
pp = spline(sample(2: 4), Y);
coeffs = pp.coefs(1, :);
d = sample(3) - sample(2);
der = [3 * coeffs(1) * d^2 + 2 * coeffs(2) * d + coeffs(3), ...
    6 * coeffs(1) * d + 2 * coeffs(2)]

coeffs = pp.coefs(2, :);
d = sample(4) - sample(3);
der = [3 * coeffs(1) * d^2 + 2 * coeffs(2) * d + coeffs(3), ...
    6 * coeffs(1) * d + 2 * coeffs(2)]

end

