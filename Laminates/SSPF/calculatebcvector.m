function [bcvector] = calculatebcvector(nodes)
%CALCULATEBCVECTOR Summary of this function goes here
%   Detailed explanation goes here
    bcvector = [];
    for i=1:size(nodes, 1)
        if(nodes(i, 4) == 1)
            bcvector = [bcvector;5*(i-1)+2;5*(i-1)+3;5*(i-1)+5];
%             bcvector = [bcvector;5*(i-1)+2;5*(i-1)+3];
            
        elseif(nodes(i, 4) == 2)
            bcvector = [bcvector;5*(i-1)+1;5*(i-1)+3;5*(i-1)+4];
%             bcvector = [bcvector;5*(i-1)+1;5*(i-1)+3];
        elseif(nodes(i, 4) == 3)
            bcvector = [bcvector;5*(i-1)+1;5*(i-1)+2;5*(i-1)+3;5*(i-1)+4;5*(i-1)+5];
        end
    end
end