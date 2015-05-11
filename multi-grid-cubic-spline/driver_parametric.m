close all;

%% Open sample
fileID = fopen('data/rabit.sample','r');
data = textscan(fileID, '%d'); 
data = double(data{1});
fclose(fileID);

dsfactor = 2;
nSeg = data(1);
ind = 2;
iSeg = 1;
sepInd = find(data == 0);
sepInd = [sepInd; length(data) + 1];

figure
hold all
axis ij
for i = 1: nSeg
    y1 = data(ind: 2: sepInd(i) - 2);
    y2 = data(ind + 1: 2: sepInd(i) - 1);
    
    if length(y1) >= 18
        y1 = y1(1: dsfactor: end);
        y2 = y2(1: dsfactor: end);
    end

    d1 = y1(1: end - 1) - y1(2: end);
    d2 = y2(1: end - 1) - y2(2: end);

    %t = cumsum([0; sqrt(d1.^2 + d2.^2)]);
    t = 1: length(y1);
    ind = sepInd(i) + 1;
    
    len = length(t);
    anchors = [round(len / 3), round(len * 2 / 3)];
    % segment too short
    if round(len / 3) <= 2
        anchors(1) = 3;
    end
    
    bc = [(y1(2) - y1(1)), (y1(end) - y1(end - 1))];
    [ pp1 ] = anchorSpline( t, y1, anchors, bc );
    bc = [(y2(2) - y2(1)), (y2(end) - y2(end - 1))];
    [ pp2 ] = anchorSpline( t, y2, anchors, bc );
    
    xi = 1: 0.1: len;
    %plot(y1, y2, '.');
    plot(ppval(pp1, xi), ppval(pp2, xi));
    
end

