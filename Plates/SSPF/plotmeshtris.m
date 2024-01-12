function [] = plotmesh(nodes, elements)
% Plots mesh. Green circles represent simply supported support, whilst blue
% are clamped supports
hold on;

%% PLOT QUADS
for i=1:size(elements, 1)
    polygon = zeros(4, 3);
    for j=1:4
        polygon(j, :) = nodes(elements(i, j), 1:3);
        %polygon(j, 3) = 0.1 * abs(sin(polygon(j, 1) * 10));
    end
    fill3(polygon(:, 1), polygon(:, 2), polygon(:, 3), 'r');
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