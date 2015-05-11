% function tests = unit_tests
% tests = functiontests(localfunctions);
% 
% function testFunctionOne(testCase)
% disp('lalala');

%% add_pp
x1 = [2 4 5 6];
y1 = sin(x1);
pp1 = spline(x1, y1);
x2 = [1 3 6 7 8];
y2 = sin(x2);
pp2 = spline(x2, y2);

pp = add_pp(pp1, pp2);
x = 1: 0.01: 8;

plot(x, ppval(pp, x));
hold on;
plot(x, ppval(pp1, x), 'm');
plot(x, ppval(pp2, x), 'r');
scatter(x1, y1);
scatter(x2, y2);
hold off;

%% test quarticSpline2

% ground truth polynomial: x^4 - x^3 + x^2 - x for both segment (relative
% to 0, no shift)
xx = [1, 3, 5];
yy = [0, 60, 520];
[ c ] = quarticSpline2( xx, yy, [2, 8; 434, 272] );
coefs = zeros(2, 5);
coefs(1, :) = c(5: -1: 1);
coefs(2, :) = c(10: -1: 6);
pp = mkpp(xx, coefs);

xi = 1: 0.1: 5;
ppvals = ppval(pp, xi);
figure
plot(xi, ppvals);
