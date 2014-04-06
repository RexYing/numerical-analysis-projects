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
%splineData = addleaf(splineData, [29, 2, 2010], 0);
for i = 1: size(inds, 1)
    splineData = removeleaf(splineData, inds(i, :));
end
% confirm
if ~isempty(find(cell2mat(splineData{3, 1}) == -9999, 1))
    error('Failed to get rid of invalid data');
else
    fprintf('\n\n Deleted invalid data (-9999)\n');
end

%% sample locs
months = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30];
months = cumsum(months);
year1 = hierInds(1, 3);
years = [0, 365, 365, 366];
years = cumsum(years);

xsample = zeros(1, length(splineData{3, 3}));
iSample = 1;
for i = 1: size(hierInds, 1)
    if maxTemp(i) == -9999
        continue;
    end
    xsample(iSample) = years(hierInds(i, 3) - year1 + 1) + months(hierInds(i, 2)) + hierInds(i, 1);
    if (mod(hierInds(i, 3), 4) == 0) && (hierInds(i, 2) > 2)
        xsample(iSample) = xsample(iSample) + 1;
    end
    iSample = iSample + 1;
end

%% spline
ppcoeffs = perform_spline(splineData, xsample);
xnodes = linspace(1, xsample(end), 30000);

lvl = 2;
pEval = ppval(ppcoeffs{lvl}, xnodes);

figure(1);
plot(xnodes, pEval, 'b.', 'MarkerSize', 4);
%sampleEval = ppval(ppcoeffs{lvl}, ppcoeffs{lvl}.breaks);
sampleEval = cell2mat(splineData{lvl, 1});
hold on;
plot(ppcoeffs{lvl}.breaks, sampleEval, 'm.', 'MarkerSize', 6);
hold off;

% --------------
% Rex Ying
% Undergraduate students at Duke CS 
% 03/14/2014
% ----------------
