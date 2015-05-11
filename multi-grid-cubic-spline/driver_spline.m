close all

filename = 'data/durham_temperature.csv';
rawData = csvread(filename, 1, 2);
%% Adaptive spline on simple data
% xx = 1: 10;
% yy = xx + sqrt(xx) + sin(xx);
% xi = 1: 0.1: 10;
%anchors = [4, 7];
ub = 80;
xx = 1: ub;
yy = rawData(1: ub, 2)';
xi = 1: 0.1: ub;
anchors = 10: 10: ub - 10;

%% Spline
subplot(2, 2, 1); 
bc = [1.5+cos(1), 1 + 1/(2*sqrt(10)) + cos(10)];
pClamped = spline(xx, [1.5+cos(1), yy, 1 + 1/(2*sqrt(10)) + cos(10)]);
plot(xi, ppval(pClamped, xi));
hold all
plot(xx, yy, 'd');

[ pp ] = anchorSpline( xx, yy, anchors, bc );

subplot(2, 2, 2);
ppvals = ppval(pp, xi);
plot(xi, ppvals);
hold all
plot(xx, yy, 'd');
plot(anchors, yy(anchors), 'm*');

%% First der
subplot(2, 2, 3);
p1DerFn = fnder(pp, 1);
plot(xi, ppval(p1DerFn, xi), 'linewidth', 2);

hold on
pClamped1DerFn = fnder(pClamped, 1);
plot(xi, ppval(pClamped1DerFn, xi));
xlabel('first derivative');

% first der diff
%subplot(3, 2, 5);

%% Second der
subplot(2, 2, 4);
p2DerFn = fnder(pp, 2);
plot(xi, ppval(p2DerFn, xi),  'linewidth', 2);

hold on
pClamped2DerFn = fnder(pClamped, 2);
plot(xi, ppval(pClamped2DerFn, xi));
xlabel('second derivative');
