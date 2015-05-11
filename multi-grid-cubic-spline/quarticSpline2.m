function [ coefs ] = quarticSpline2( xx, yy, der )
%QUARTICSPLINE2 Quartic spline with two intervals.
%   Known conditions: 1st, 2nd, derivatives at boundary and function values
%   at boundary and the one knot in between.
%   10 unknown coefficients solved by 10 lineary equations.
%
%   INPUT:
%   xx: vector of length 3 representing sample positions
%   yy: vector of length 3 representing sample values
%   der: [2-by-2] matrix. derivatives(i, j) represents the jth
%       derivative of left boundary (i=1), and right boundary (i = 2)
%
%
% if the two polynomials are
%   a1 + b1 * x + c1 * x^2 + d1 * x^3 + e1 * x^4
%   a2 + b2 * x + c2 * x^2 + d2 * x^3 + e2 * x^4
% then
%   coefs = [a1, b1, c1, d1, e1, a2, b2, c2, d2, e2]
%

d1 = xx(2) - xx(1);
d2 = xx(3) - xx(2);

A = zeros(10, 10);
A(1, 1) = 1;
A(2, 2) = 1;
A(3, 3) = 2;

A(4, 1: 5) = [1, d1, d1^2, d1^3, d1^4];
% the second quartic polynomial sets 0 at xx(2)
A(5, 2: 7) = [1, 2*d1, 3*d1^2, 4*d1^3, 0, -1];
%A(5, :) = [0, 1, 2*d1, 3*d1^2, 4*d1^3, 0, -1, -2*d1, -3*d1^2, -4*d1^3];
A(6, 3: 8) = [2, 6*d1, 12*d1^2, 0, 0, -2];
A(7, 6) = 1;

A(8, 6: 10) = [1, d2, d2^2, d2^3, d2^4];
A(9, 7: 10) = [1, 2*d2, 3*d2^2, 4*d2^3];
A(10, 8: 10) = [2, 6*d2, 12*d2^2];

b = [yy(1); der(1, 1); der(1, 2); yy(2); 0; 0; yy(2); yy(3); der(2, 1); der(2, 2)];

coefs = A \ b;


end

