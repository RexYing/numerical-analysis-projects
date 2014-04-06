function [ pp ] = combine_pp( pp1, pp2 )
%COMBINE_PP Combine piecewise polynomial data (1D)
%   
% the last break of pp1 has to be the first break of pp2
% Combine pp1 and pp2 in order.
%

pp = pp1;
pp.breaks = [pp1.breaks(1: end - 1), pp2.breaks];
pp.coefs = [pp1.coefs; pp2.coefs];
pp.pieces = pp1.pieces + pp2.pieces;

end

% --------------
% Rex Ying
% Undergraduate students at Duke CS 
% 03/17/2014
% ----------------