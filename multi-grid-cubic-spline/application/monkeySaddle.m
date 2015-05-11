function [ Z, bd ] = monkeySaddle( X, Y )
%MONKEYSADDLE Monkey saddle surface values computed analytically
%   
%   http://mathworld.wolfram.com/MonkeySaddle.html
%
% bd: a struct with four fields (left, right, top, bottom): first derivative boundary conditions
%   left / right are the partial derivatives with respect to x on the left/right
%   boundaries
%   top / bottom are the partial derivatives with respect to y on the
%   top/bottom boundaries
%   

x = X(1, :);
y = Y(:, 1)';

Z = X.^3 - 3*X.*Y.^2;

% at left, x is x(1)
bd = struct();
bd.left = 3 * x(1) ^ 2 - 3 * y.^2;
bd.right = 3 * x(end) ^ 2 - 3 * y.^2;
% at top, y is y(1)
bd.top = -6 * x * y(1);
bd.bottom = -6 * x * y(end);

end
