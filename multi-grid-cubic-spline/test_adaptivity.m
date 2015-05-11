
removeInd = 14;

figure(2)
plot(xi,  ppval(pp, xi));
title('Before removal');

rmPts = (2: 9) * 7; % points to be removed

for i = 1: length(rmPts)
    removeInd = rmPts(i)
    [ ppNew, xx, yy ] = anchorSplineRm( xx, yy, anchors, pp, removeInd );

    figure;

    hold on
    % Recover
    legend();
    plot(xi,  ppval(ppNew, xi));
    % title('After removal');

    % compare with direct spline of the new sample points
    %figure(4)
    inds = [1: removeInd - 1, removeInd + 1: length(xx)];
    pp1 = spline(xx(inds), [1.5+cos(1), yy(inds), 1 + 1/(2*sqrt(10)) + cos(10)]);
    plot(xi,  ppval(pp1, xi));
    legend('adaptive spline after removal', 'traditional spline');
    %title('Traditional spline');

    %plot(xi, ppval(ppNew, xi) - ppval(pp1, xi));

    % distance
    p = ppval(ppNew, xi);
    q = ppval(pp1, xi);
    %[cm, cSq] = DiscreteFrechetDist(p', q');
    %fprintf('Frechet Distance: %d\n', cm);
end