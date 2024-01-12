function [nodes] = supportedbcsquareplate(nodes)
%APPLYBCS Summary of this function goes here
%   Detailed explanation goes here
    
    minx = min(nodes(:, 1));
    miny = min(nodes(:, 2));
    
    maxx = max(nodes(:, 1));
    maxy = max(nodes(:, 2));
    
    nodes(:, 4) = 0;
    for i=1:size(nodes, 1)
        if(nodes(i, 1) == maxx || nodes(i, 1) == minx)
            nodes(i, 4) = 1;
        end
        if(nodes(i, 2) == maxy || nodes(i, 2) == miny)
            nodes(i, 4) = 2;
        end
    end
end

