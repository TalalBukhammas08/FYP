function [k] = FSDTLocalStiffness(m, coords)
%FSDTLOCALSTIFFNESS Summary of this function goes here
%   m=material

    %Evaluation point of integration
    evalpoints = [1/sqrt(3);-1/sqrt(3)];
    evalpointsbending = [sqrt(0.6);0;-sqrt(0.6)];
    %Evaluation weight of integration
    weights = [1;1];
    weightsbending = [5/9;8/9;5/9];
    k = zeros(3 * 8, 3 * 8);
    
    for x=1:size(evalpointsbending, 1)
        for e=1:size(evalpointsbending, 1)
            xi = evalpointsbending(x);
            eta = evalpointsbending(e);
            
            N1 = -(1-eta)*(1-xi)*(1+xi+eta)/4;
            N2 = -(1-eta)*(1+xi)*(1-xi+eta)/4;
            N3 = -(1+eta)*(1+xi)*(1-xi-eta)/4;
            N4 = -(1+eta)*(1-xi)*(1+xi-eta)/4;

            N5 = (1-eta)*(1-xi)*(1+xi)/2;
            N6 = (1-eta)*(1+xi)*(1+eta)/2;
            N7 = (1+eta)*(1-xi)*(1+xi)/2;
            N8 = (1-eta)*(1-xi)*(1+eta)/2;
            
            dN1dxi = -0.25*(eta - 1)*(eta + xi + 1) - 0.25*(eta - 1)*(xi - 1);
            dN1deta = -0.25*(xi - 1)*(eta + xi + 1) - 0.25*(eta - 1)*(xi - 1);
            dN1 = [dN1dxi;dN1deta];
            
            dN2dxi = 0.25*(eta - 1)*(eta - xi + 1) - 0.25*(eta - 1)*(xi + 1);
            dN2deta = 0.25*(xi + 1)*(eta - xi + 1) + 0.25*(eta - 1)*(xi + 1);
            dN2 = [dN2dxi;dN2deta];
            
            dN3dxi = 0.25*(eta + 1)*(eta + xi - 1) + 0.25*(eta + 1)*(xi + 1);
            dN3deta = 0.25*(xi + 1)*(eta + xi - 1) + 0.25*(eta + 1)*(xi + 1);
            dN3 = [dN3dxi;dN3deta];
            
            dN4dxi = 0.25*(eta + 1)*(xi - eta + 1) + 0.25*(eta + 1)*(xi - 1);
            dN4deta = 0.25*(xi - 1)*(xi - eta + 1) - 0.25*(eta + 1)*(xi - 1);
            dN4 = [dN4dxi;dN4deta];
            
            dN5dxi = 0.5*(eta - 1)*(xi - 1) + 0.5*(eta - 1)*(xi + 1);
            dN5deta = 0.5*(xi - 1)*(xi + 1);
            dN5 = [dN5dxi;dN5deta];
            
            dN6dxi = -0.5*(eta - 1)*(eta + 1);
            dN6deta = -0.5*(eta - 1)*(xi + 1) - 0.5*(eta + 1)*(xi + 1);
            dN6 = [dN6dxi;dN6deta];
            
            dN7dxi = -0.5*(eta + 1)*(xi - 1) - 0.5*(eta + 1)*(xi + 1);
            dN7deta = -0.5*(xi - 1)*(xi + 1);
            dN7 = [dN7dxi;dN7deta];
            
            dN8dxi = 0.5*(eta - 1)*(eta + 1);
            dN8deta = 0.5*(eta - 1)*(xi - 1) + 0.5*(eta + 1)*(xi - 1);
            dN8 = [dN8dxi;dN8deta];
            
            Ni = [N1, N2, N3, N4, N5, N6, N7, N8];
            dNi = [dN1, dN2, dN3, dN4, dN5, dN6, dN7, dN8];

            xdifxi = sum(dNi(1, :) * coords(:, 1));
            xdifeta = sum(dNi(2, :) * coords(:, 1));

            ydifxi = sum(dNi(1, :) * coords(:, 2));
            ydifeta = sum(dNi(2, :) * coords(:, 2));

            J = [xdifxi, xdifeta; ydifxi, ydifeta];

            JTransInv = (inv(J)).';

            B1f = [1, 0, 0, 0; 0, 0, 0, 1; 0, 1, 1, 0];
            B2f = zeros(4, 4);

            B2f(1:2, 1:2) = JTransInv;
            B2f(3:4, 3:4) = JTransInv;

            B3f = zeros(4, 3*length(Ni));
            for i=1:3:length(Ni) * 3
                index = (i - 1) / 3 + 1;
                B3f(1:4, i:i+2) = [0,    dNi(1, index),   0;
                                   0,    dNi(2, index),   0;
                                   0,    0,               dNi(1, index);
                                   0,    0,               dNi(2, index)]; 
            end

            Bf = B1f * B2f * B3f;
            
            Df = m.E/(1 - m.nu^2) * [1, m.nu, 0; m.nu, 1, 0;0, 0, (1-m.nu)/2];

            k = k + m.thickness^3 / 12 * weightsbending(x) * weightsbending(e) * Bf.' * Df * Bf * det(J);
        end
    end
    
    
    for x=1:size(evalpoints, 1)
        for e=1:size(evalpoints, 1)
            xi = evalpoints(x);
            eta = evalpoints(e);
            
            N1 = -(1-eta)*(1-xi)*(1+xi+eta)/4;
            N2 = -(1-eta)*(1+xi)*(1-xi+eta)/4;
            N3 = -(1+eta)*(1+xi)*(1-xi-eta)/4;
            N4 = -(1+eta)*(1-xi)*(1+xi-eta)/4;

            N5 = (1-eta)*(1-xi)*(1+xi)/2;
            N6 = (1-eta)*(1+xi)*(1+eta)/2;
            N7 = (1+eta)*(1-xi)*(1+xi)/2;
            N8 = (1-eta)*(1-xi)*(1+eta)/2;
            
            dN1dxi = -0.25*(eta - 1)*(eta + xi + 1) - 0.25*(eta - 1)*(xi - 1);
            dN1deta = -0.25*(xi - 1)*(eta + xi + 1) - 0.25*(eta - 1)*(xi - 1);
            dN1 = [dN1dxi;dN1deta];
            
            dN2dxi = 0.25*(eta - 1)*(eta - xi + 1) - 0.25*(eta - 1)*(xi + 1);
            dN2deta = 0.25*(xi + 1)*(eta - xi + 1) + 0.25*(eta - 1)*(xi + 1);
            dN2 = [dN2dxi;dN2deta];
            
            dN3dxi = 0.25*(eta + 1)*(eta + xi - 1) + 0.25*(eta + 1)*(xi + 1);
            dN3deta = 0.25*(xi + 1)*(eta + xi - 1) + 0.25*(eta + 1)*(xi + 1);
            dN3 = [dN3dxi;dN3deta];
            
            dN4dxi = 0.25*(eta + 1)*(xi - eta + 1) + 0.25*(eta + 1)*(xi - 1);
            dN4deta = 0.25*(xi - 1)*(xi - eta + 1) - 0.25*(eta + 1)*(xi - 1);
            dN4 = [dN4dxi;dN4deta];
            
            dN5dxi = 0.5*(eta - 1)*(xi - 1) + 0.5*(eta - 1)*(xi + 1);
            dN5deta = 0.5*(xi - 1)*(xi + 1);
            dN5 = [dN5dxi;dN5deta];
            
            dN6dxi = -0.5*(eta - 1)*(eta + 1);
            dN6deta = -0.5*(eta - 1)*(xi + 1) - 0.5*(eta + 1)*(xi + 1);
            dN6 = [dN6dxi;dN6deta];
            
            dN7dxi = -0.5*(eta + 1)*(xi - 1) - 0.5*(eta + 1)*(xi + 1);
            dN7deta = -0.5*(xi - 1)*(xi + 1);
            dN7 = [dN7dxi;dN7deta];
            
            dN8dxi = 0.5*(eta - 1)*(eta + 1);
            dN8deta = 0.5*(eta - 1)*(xi - 1) + 0.5*(eta + 1)*(xi - 1);
            dN8 = [dN8dxi;dN8deta];
            
            Ni = [N1, N2, N3, N4, N5, N6, N7, N8];
            dNi = [dN1, dN2, dN3, dN4, dN5, dN6, dN7, dN8];

            xdifxi = sum(dNi(1, :) * coords(:, 1));
            xdifeta = sum(dNi(2, :) * coords(:, 1));

            ydifxi = sum(dNi(1, :) * coords(:, 2));
            ydifeta = sum(dNi(2, :) * coords(:, 2));

            J = [xdifxi, xdifeta; ydifxi, ydifeta];

            JTransInv = (inv(J)).';

            B1c = [1, 0, 1, 0; 0, 1, 0, 1];

            B2c = zeros(4, 4);
            B2c(1:2, 1:2) = JTransInv;
            B2c(3:4, 3:4) = [1, 0;0, 1];

            B3c = zeros(4, 3*length(Ni));
            for i=1:3:length(Ni) * 3
                index = (i - 1) / 3 + 1;
                B3c(1:4, i:i+2) = [dNi(1, index),   0,         0;
                                   dNi(2, index),   0,         0;
                                   0,               Ni(index), 0;
                                   0,               0,         Ni(index)]; 
            end
            
            Bc = B1c * B2c * B3c;
            Dc = [m.G, 0; 0, m.G];

            k = k + m.alpha * m.thickness * weights(x) * weights(e) * Bc.' * Dc * Bc * det(J);
        end
    end
    
end
