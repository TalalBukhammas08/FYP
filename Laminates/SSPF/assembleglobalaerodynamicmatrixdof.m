function [Ka] = assembleglobalaerodynamicmatrixdof(bcvector, nodes, elements, dofpernode)
%CALCULATESTIFFNESSMATRIX Summary of this function goes here
%   Detailed explanation goes here
    
    KaSize = size(nodes, 1) * dofpernode;
    mapping = sparsemapping(KaSize, bcvector);
    
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
        %scatter3(elementnodevectors(:, 1), elementnodevectors(:, 2), [0;0;0;0]);
        coords = elementnodevectors(1:8, :);
        localstiffness = AerodynamicStiffness(coords);
        
        elementnodesindices = elements(i, 1:8);
        
        for v = 1:8
           for h = 1:8
               vv = dofpernode * (elementnodesindices(v) - 1) + 1;
               hh = dofpernode * (elementnodesindices(h) - 1) + 1;
               
               vindex = dofpernode*(v-1) + 1;
               hindex = dofpernode*(h-1) + 1;
                   
               for ii=vv:vv+dofpernode-1
                   for jj=hh:hh+dofpernode-1
                       iindex = mapping(ii);
                       jindex = mapping(jj);
                       if(iindex ~= 0 && jindex ~= 0)
                           rows(vecindex) = iindex;
                           cols(vecindex) = jindex;
                           values(vecindex) = localstiffness((ii - vv) + vindex, (jj - hh) + hindex);
                           vecindex = vecindex + 1;
                       end
                   end
               end
           end
        end
    end
    Ka = sparse(rows, cols, values, KaSize-size(bcvector, 1), KaSize-size(bcvector, 1));
end

