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
splineData = build_multigrid(hierInds, maxTemp);
% find indices of invalid data
inds = hierInds(maxTemp == -9999, :);

% test
splineData = addleaf(splineData, [29, 2, 2010], 0);
for i = 1: size(inds, 1)
    splineData = removeleaf(splineData, inds(i, :));
end
% confirm
find(cell2mat(splineData{3, 1}) == -9999)

% --------------
% Rex Ying
% Undergraduate students at Duke CS 
% 03/14/2014
% ----------------
