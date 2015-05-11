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

figure
hold on
scatter3(X(:), Y(:), Z(:), 'r.');
surf(X,Y,Z);
title('Monkey Saddle');
xlabel('x');
ylabel('y');
zlabel('z');
hold off

%% Anchor points
anchorStep = 4;
% Kronecker product of 1D splines
anchorXInds = 1: (anchorStep/step): length(x);
anchorYInds = 1: (anchorStep/step): length(y);
anchorX = minX: anchorStep: maxX;
anchorY = minY: anchorStep: maxY;
[gridX, gridY] = meshgrid(anchorX, anchorY);
[anchorZ, anchorBd] = monkeySaddle(gridX, gridY);

[ pp ] = anchorSpline( x, Z(1, :), anchorXInds(2: end-1), [bd.left(1), bd.right(1)] );


%% Display result

% xi: dense sample locations to show interpolation
xi = minX: 0.1: maxX;
ppvals = ppval(pp, xi);

figure
plot(xi, ppvals);

step = 0.1;
