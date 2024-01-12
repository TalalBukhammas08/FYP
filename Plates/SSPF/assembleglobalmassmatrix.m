function [M] = assembleglobalmassmatrix(m, bcvector, nodes, elements)
%CALCULATESTIFFNESSMATRIX Summary of this function goes here
%   Detailed explanation goes here
    
    MSize = size(nodes, 1) * 3;
    mapping = sparsemapping(MSize, bcvector);
    

    rows = ones(40^2 * size(elements, 1), 1);
    cols = ones(40^2 * size(elements, 1), 1);
    values = zeros(40^2 * size(elements, 1), 1);
    
    vecindex = 1;
    
    %Vector containing the positions of all the nodes in current element
    elementnodevectors = zeros(8, 2);
    for i=1:size(elements, 1)
        
        %Loop through nodes in each element
        for n=1:8
           elementnodevectors(n, :) = nodes(elements(i, n), 1:2); 
        end
        coords = elementnodevectors(1:8, :);
        localmassmatrix = FSDTLocalMassMatrix(m, coords);
        
        elementnodesindices = elements(i, 1:8);
        
        for v = 1:8
           for h = 1:8
               vv = 3 * (elementnodesindices(v) - 1) + 1;
               hh = 3 * (elementnodesindices(h) - 1) + 1;
               
               vindex = 3*(v-1) + 1;
               hindex = 3*(h-1) + 1;
                   
               for ii=vv:vv+2
                   for jj=hh:hh+2
                       iindex = mapping(ii);
                       jindex = mapping(jj);
                       if(iindex ~= 0 && jindex ~= 0)
                           rows(vecindex) = iindex;
                           cols(vecindex) = jindex;
                           values(vecindex) = localmassmatrix((ii - vv) + vindex, (jj - hh) + hindex);
                           vecindex = vecindex + 1;
                       end
                   end
               end
           end
        end
    end
    M = sparse(rows, cols, values, MSize-size(bcvector, 1), MSize-size(bcvector, 1));
end

