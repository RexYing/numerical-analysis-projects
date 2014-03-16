%% Use weather data as an example
%
% Anchor nodes are the averages
clear all;

filename = 'data/durham_temperature.csv';
rawData = csvread(filename, 1, 2);

depth = 3;
% in this case, the years/months/days are already sorted.
% in general, the indices should be ordered.
hierInds = zeros(size(rawData, 1), depth);
hierInds(:, 1) = mod(rawData(:, 1), 100);
hierInds(:, 2) = mod(floor(rawData(:, 1) / 100), 100);
hierInds(:, 3) = floor(rawData(:, 1) / 10000);

maxTemp = rawData(:, 2);
splineData = build_tree(hierInds, maxTemp);

% --------------
% Rex Ying
% Undergraduate students at Duke CS 
% 03/14/2014
% ----------------
