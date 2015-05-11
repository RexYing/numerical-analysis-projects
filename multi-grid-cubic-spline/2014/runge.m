function [ y ] = runge( x  )
% calling sequence 
% y = runge( x ) 
% 
% Input  : 
%   x is a single element or a vector of multiple elements in [-1,1]
%  
% Output : 
%   y is the Runge function value(s) at the input x 
%         y = 1/ ( 1 + 25 x^2 )

% Purpose
% -------
%   Used for a case study of polynomial interpolation methods 
%   
%   The Runge function is a simple one in a large class of 
%   distribution functions, but it shows certain fundamental 
%   characteristics.
% 

y = 1./( 1 + 25*x.^2 ); 

return 

% --------------
% Xiaobai Sun 
% Duke CS 
% for NA classes 
% ---------------