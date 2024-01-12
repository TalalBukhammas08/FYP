function [nodes] = supportedbccircularplate(nodes)
%APPLYBCS Summary of this function goes here
%   Detailed explanation goes here
    
    minx = min(nodes(:, 1));
    miny = min(nodes(:, 2));
    
    maxx = max(nodes(:, 1));
    maxy = max(nodes(:, 2));
    
    nodes(:, 4) = 0;
    for i=1:size(nodes, 1)
        if(norm(nodes(i, 1:3)) < 1.2 && norm(nodes(i, 1:3)) > 0.99)
            nodes(i, 4) = 1;
        end
    end
end

