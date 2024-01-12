function [massmatrix] = FSDTMassMatrixIntegral(coords, rho, thickness)
    syms z xi eta B3c B3f;
        
    N1 = -(1-eta)*(1-xi)*(1+xi+eta)/4;
    N2 = -(1-eta)*(1+xi)*(1-xi+eta)/4;
    N3 = -(1+eta)*(1+xi)*(1-xi-eta)/4;
    N4 = -(1+eta)*(1-xi)*(1+xi-eta)/4;

    N5 = (1-eta)*(1-xi)*(1+xi)/2;
    N6 = (1-eta)*(1+xi)*(1+eta)/2;
    N7 = (1+eta)*(1-xi)*(1+xi)/2;
    N8 = (1-eta)*(1-xi)*(1+eta)/2;
    
    Ni = [N1, N2, N3, N4];
    
    x = sum(Ni * coords(:, 1));
    y = sum(Ni * coords(:, 2));
    
    Ni = [N1, N2, N3, N4, N5, N6, N7, N8];
    Nmatrix = zeros(3, 24);
    for i=1:8
        Nmatrix(:, 3*(i-1)+1:3*(i-1)+3) = [Ni(i), 0, 0;
                                           0, Ni(i), 0;
                                           0, 0, Ni(i)];
    end
    
    J = [diff(x, xsi), diff(x, eta); diff(y, xi), diff(y, eta)];
    
    
    massmatrix = double(int(rho * Ni.' * [thickness, 0, 0;0, thickness^3/12, 0;0, 0, thickness^3/12] * Ni * det(J), xsi, eta));
end

