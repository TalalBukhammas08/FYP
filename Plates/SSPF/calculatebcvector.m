function [bcvector] = calculatebcvector(nodes)
%CALCULATEBCVECTOR Summary of this function goes here
%   Detailed explanation goes here
    bcvector = [];
    for i=1:size(nodes, 1)
        if(nodes(i, 4) == 1)
            bcvector = [bcvector;3*(i-1)+1];
        elseif(nodes(i, 4) == 2)
            bcvector = [bcvector;3*(i-1)+1;3*(i-1)+2;3*(i-1)+3];
        end
    end
end

