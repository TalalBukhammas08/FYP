function [] = plotloads(nodes, F, scale, skip)
%PLOTLOADS Plots the loads
%   Detailed explanation goes here
    hold on;
    directionvectors = [];
    positionvectors = [];
    for i=1:3*skip:size(F, 1)
        positionvectors = [positionvectors;nodes((i - 1)/3 + 1, :)];
        directionvectors = [directionvectors; 0, 0, sign(F(i))*scale];
    end
    %q = quiver3(positionvectors(:, 1), positionvectors(:, 2), positionvectors(:, 3), directionvectors(:, 1), directionvectors(:, 2), directionvectors(:, 3));
    arrow3(positionvectors(:, 1:3), positionvectors(:, 1:3) + directionvectors(:, 1:3), 'b');
    %q.AutoScale = 'off';
end

