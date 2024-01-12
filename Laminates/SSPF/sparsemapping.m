function [mapping] = sparsemapping(msize, vec)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    mapping = zeros(msize, 1);
    
    currentindex = 0;
    for i=1:msize
        try
            mapping(i) = i - currentindex;
            if(vec(currentindex + 1) == i)
                currentindex = currentindex + 1;
                mapping(i) = 0;
            end
        catch
        end
    end
end

