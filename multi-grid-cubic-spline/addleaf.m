function [ multigrid ] = addleaf( multigrid, index, data )
%ADDLEAF Add a data entry. Its ancestors are determined by the index.
%   
% multigrid: data in the form of a multigrid tree, produced by build_tree.m
% index: a vector indicating the index of the data being added. The length
%   of the vector is equal to the levels of the multigrid.
% data: one or an array of data, which have to be consistent with the data
% type of the multigrid.
%

lvl = size(multigrid, 1);


groupInd = 1;
for depth = 1: lvl
    if groupInd == 1
        iStart = 1;
    else
        iStart = multigrid{depth, 2}(groupInd - 1) + 1;
    end
    iEnd = multigrid{depth, 2}(groupInd);
    % search for the position to insert
    ind = binary_search(multigrid{depth, 3}(iStart: iEnd), index(depth));
    groupInd = iStart - 1 + ind
end

end

% --------------
% Rex Ying
% Undergraduate students at Duke CS 
% 03/16/2014
% ----------------