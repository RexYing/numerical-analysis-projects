function [ pp ] = splineBetweenAnchors( xx, yy, bc )
%SPLINEBETWEENANCHORS compute spline curve between two anchor points
%
% Description:
%		The spline orders are 4, 3, 3, ..., 3, 4.
%		This is done by first building a non-standard base spline of orders 2, 1, 1, ..., 1, 2,
%		and raise order by the 2-degree connections
%   
% Params:
%   xx: [n-by-1] vector of sample locations between 2 anchors. The first
%       and last elements are the locations of anchors.
%   yy: [n-by-1] vector of sample values between 2 anchors.
%   bc: [2-by-3] matrix of boundary conditions. The first row contains the value, first
%   derivative, second derivative at left anchor; The second row contains
%   the value, first derivative, second derivative at right anchor.
%
%	Return:
% 	Spline curve as piecewise polynomial structure in MATLAB
%

% find the quadratic piecewise polynomials for first and last segment


end

