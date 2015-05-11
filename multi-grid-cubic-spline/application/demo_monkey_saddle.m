%% Demo: using adaptive spline to draw monkey saddle surface (2D spline)
%

close all;

minX = -4; maxX = -minX;
minY = -4; maxY = -minY;
step = 0.5;
x = minX: step: maxX;
y = minY: step: maxY;

[X,Y] = meshgrid(x,y);

[Z, bd] = monkeySaddle(X, Y);

%% Anchor points
anchorStep = 4;
% Kronecker product of 1D splines
anchorXInds = 1: (anchorStep/step): length(x);
anchorYInds = 1: (anchorStep/step): length(y);
anchorX = minX: anchorStep: maxX;
anchorY = minY: anchorStep: maxY;
[gridX, gridY] = meshgrid(anchorX, anchorY);
[anchorZ, anchorBd] = monkeySaddle(gridX, gridY);

%% Dense samples
% xi: dense sample locations to show interpolation
interpStep = 0.1;
xi = minX: interpStep: maxX;
yi = minY: interpStep: maxY;
[gridXi, gridYi] = meshgrid(xi, yi);
% analytically obtain the Z values as reference
[refZ, refBd] = monkeySaddle(gridXi, gridYi);

%% Perform 2D spline

% first: interp from step=4 to step=0.5
splineZ = zeros(length(xi), length(yi));

% horizontal sweep
for i = 1: length(y)
    [ pp ] = anchorSpline( x, Z(i, :), anchorXInds(2: end-1), [bd.left(i), bd.right(i)] );
    splineZ((i-1)*5+1, :) = ppval(pp, xi); % TODO better indexing
end
figure
imagesc(splineZ);

% vertical sweep
for i = 1: length(xi) % index in X
    [ pp ] = anchorSpline( y, splineZ(1: 5: end, i), anchorYInds(2: end-1), [refBd.top(i), refBd.bottom(i)] );
    splineZ(:, i) = ppval(pp, yi);
end

%% Display result

figure

numFigsRow = 2;
numFigsCol = 2;

subplot(numFigsRow, numFigsCol, 1);
hold on
%scatter3(X(:), Y(:), Z(:), 'r.');
surf(X,Y,Z);
view([45, 45]);
title('Monkey saddle surface');
xlabel('x');
ylabel('y');
zlabel('z');
hold off

subplot(numFigsRow, numFigsCol, 2);
hold on
scatter3(gridX(:), gridY(:), anchorZ(:), 'r.');
surf(gridXi, gridYi, splineZ);
view([45, 45]);
title('Interpolated monkey saddle using adaptive splines');
xlabel('x');
ylabel('y');
zlabel('z');
hold off

subplot(numFigsRow, numFigsCol, 3);
imagesc(splineZ - refZ);
colorbar;
title('Difference between analytical and adaptive splines');
xlabel('x');
ylabel('y');
