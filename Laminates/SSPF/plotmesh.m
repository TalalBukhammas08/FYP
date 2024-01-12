function [] = plotmesh(nodes, elements)
% Plots mesh. Green circles represent simply supported support, whilst blue
% are clamped supports
hold on;

%% PLOT TRIANGLES
tris = [1, 5, 8;5, 2, 6;6, 3, 7;7, 4, 8;5, 7, 8;5, 6, 7];
for i=1:size(elements, 1)
    polygon = zeros(size(tris, 1), 3);
    for t=1:size(tris, 1)
        polygon = zeros(3, 3);
        for j=1:3
            polygon(j, 1:3) = nodes(elements(i, tris(t, j)), 1:3);
        end
        fill3(polygon(:, 1), polygon(:, 2), polygon(:, 3), 'r');
    end
    %fill3(polygon(:, 1), polygon(:, 2), polygon(:, 3), 'r');
end


%% PLOT BCS
supported = [];
clamped = [];
for i=1:size(nodes, 1)
    if(nodes(i, 4) == 1)
        supported = [supported;nodes(i, 1), nodes(i, 2), nodes(i, 3)];
    end
    
    if(nodes(i, 4) == 2)
        clamped = [clamped;nodes(i, 1), nodes(i, 2), nodes(i, 3)];
    end
end
%% PLOT BCS
supported = [];
clamped = [];
for i=1:size(nodes, 1)
    %text(nodes(i, 1), nodes(i, 2), nodes(i, 3) + 0.05, num2str(i));
    if(nodes(i, 4) == 1)
        supported = [supported;nodes(i, 1), nodes(i, 2), nodes(i, 3)];
    end
    
    if(nodes(i, 4) == 2)
        clamped = [clamped;nodes(i, 1), nodes(i, 2), nodes(i, 3)];
    end
end
if(~isnan(supported))
    scatter3(supported(:, 1), supported(:, 2), supported(:, 3), 'g');
end
if(~isnan(clamped))
    scatter3(clamped(:, 1), clamped(:, 2), clamped(:, 3), 'b');
end
axis([0, 1, 0, 1, 0, 1]);
daspect([1, 1, 1]);
xlabel('x');
ylabel('y');
zlabel('z');
hold off;
end