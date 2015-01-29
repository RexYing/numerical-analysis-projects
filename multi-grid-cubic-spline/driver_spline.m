%% Adaptive spline on simple data
xx = 1: 10;
yy = xx + sqrt(xx) + sin(xx);
plot(xx, yy);

anchors = [4, 7];
bc = [2, 20];
[ derivatives ] = anchorSpline( xx, yy, anchors, bc );

