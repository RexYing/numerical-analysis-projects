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