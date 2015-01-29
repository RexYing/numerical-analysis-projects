ratio = 4;
nDepth = 3;
img = double(imread('data/lena.gif'));
[nRow, nCol] = size(img);

anchorImg = imresize(img, 1 / ratio^(nDepth - 1));

% first lvl
interpImg = imresize(anchorImg, ratio^(nDepth - 1), 'lanczos3');
residue = img - interpImg;
fprintf('residue: %f', norm(residue(:)));

% second lvl
anchorImg = zeros(ratio * size(anchorImg));
for i = 1: nRow / ratio
    for j = 1: nCol / ratio
        r = (i-1) * ratio + 1;
        c = (j-1) * ratio + 1;
    end
end
