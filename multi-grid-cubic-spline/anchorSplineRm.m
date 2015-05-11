function [ ppNew, xx, yy ] = anchorSplineRm( xx, yy, anchors, pp, removedInd )
%ANCHORSPLINERM Summary of this function goes here
%   Detailed explanation goes here

anchorInd = 1; % anchor on the right of removed ind
while removedInd >= anchors(anchorInd)
    anchorInd = anchorInd + 1;
end
%TODO: right boundary condition

Y = yy(anchors(anchorInd - 1): anchors(anchorInd));
sample = xx(anchors(anchorInd - 1): anchors(anchorInd));
sample(removedInd - anchors(anchorInd - 1) + 1) = [];
Y(removedInd - anchors(anchorInd - 1) + 1) = [];
pp1 = spline(sample, Y);

ppNew = pp;

% remove 4th degree coefs at two anchors
ppNew.coefs(anchors(anchorInd - 1), 1) = 0;
ppNew.coefs(anchors(anchorInd) - 1, 1) = 0;

% remove extra polynomial due to removal of sample point
ppNew.coefs(removedInd, :) = [];

a1 = anchors(anchorInd - 1);
a2 = anchors(anchorInd) - 1;
ppNew.coefs(a1: a2 - 1, 2: end) = pp1.coefs;
ppNew.pieces = ppNew.pieces - 1;
ppNew.breaks(removedInd) = [];

%% Make derivatives on right anchor agree
% boundary of the quartic spline of 2 intervals
boundary = [ppNew.breaks(a2 - 1); ppNew.breaks(a2 + 1)];
p1DerFn = fnder(ppNew, 1);
p1Der = ppval(p1DerFn, boundary);
p2DerFn = fnder(ppNew,2);
p2Der = ppval(p2DerFn, boundary);
der = [p1Der, p2Der];

sample = ppNew.breaks(a2 - 1): ppNew.breaks(a2 + 1);
Y = yy(sample);
quarticCoefs = quarticSpline2(sample, Y, der);

% modify pp

if (ppNew.order == 4)
    ppNew.coefs = [zeros(ppNew.pieces, 1), ppNew.coefs];
    ppNew.order = 5;
end
ppNew.coefs(a2 - 1, :) = quarticCoefs(5: -1: 1);
ppNew.coefs(a2, :) = quarticCoefs(10: -1: 6);

%left
anchorInd = anchorInd - 1;
p1DerFn = fnder(ppNew, 1);
p1Der = ppval(p1DerFn, [anchors(anchorInd) - 1; anchors(anchorInd) + 1]);
p2DerFn = fnder(ppNew,2);
p2Der = ppval(p2DerFn, [anchors(anchorInd) - 1; anchors(anchorInd) + 1]);
der = [p1Der, p2Der];
Y = yy(anchors(anchorInd) - 1: anchors(anchorInd) + 1 );
sample = xx(anchors(anchorInd) - 1: anchors(anchorInd) + 1);
quarticCoefs = quarticSpline2(sample, Y, der);

% modify pp

ppNew.coefs(anchors(anchorInd) - 1, :) = quarticCoefs(5: -1: 1);
ppNew.coefs(anchors(anchorInd), :) = quarticCoefs(10: -1: 6);

xx(removedInd) = [];
yy(removedInd) = [];

end

