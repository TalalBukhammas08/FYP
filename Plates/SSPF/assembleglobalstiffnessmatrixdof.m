function [K] = assembleglobalstiffnessmatrixdof(m, bcvector, nodes, elements, dofpernode)
%CALCULATESTIFFNESSMATRIX Summary of this function goes here
%   Detailed explanation goes here
    
    KSize = size(nodes, 1) * dofpernode;
    mapping = sparsemapping(KSize, bcvector);
    
    spalloccount = 0;
    for i=1:size(elements, 1)
        elementnodesindices = elements(i, 1:8);
        
        for v = 1:8
           for h = 1:8
               vv = dofpernode * (elementnodesindices(v) - 1) + 1;
               hh = dofpernode * (elementnodesindices(h) - 1) + 1;

               for ii=vv:vv+dofpernode-1
                   for jj=hh:hh+dofpernode-1
                       iindex = mapping(ii);
                       jindex = mapping(jj);
                       if(iindex ~= 0 && jindex ~= 0)
                           spalloccount = spalloccount + 1;
                       end
                   end
               end
           end
        end
    end
    
    %spalloccount = size(nodes, 1) * 15;
    K = spalloc(KSize - size(bcvector, 1), KSize - size(bcvector, 1), spalloccount);
    
    %Vector containing the positions of all the nodes in current element
    elementnodevectors = zeros(8, 2);
    for i=1:size(elements, 1)
        
        %Loop through nodes in each element
        for n=1:8
           elementnodevectors(n, :) = nodes(elements(i, n), 1:2); 
        end
        %scatter3(elementnodevectors(:, 1), elementnodevectors(:, 2), [0;0;0;0]);
        coords = [elementnodevectors(1, :);elementnodevectors(2, :);elementnodevectors(3, :);elementnodevectors(4, :);elementnodevectors(5, :);elementnodevectors(6, :);elementnodevectors(7, :);elementnodevectors(8, :)];
        localstiffness = FSDTLocalStiffness(m, coords);
        
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
                           K(iindex, jindex) = K(iindex, jindex) + localstiffness((ii - vv) + vindex, (jj - hh) + hindex);
                       end
                   end
               end
           end
        end
    end
end

