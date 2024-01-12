function [ABD] = laminateabd(shearcorrectionfactor, angles, totalthickness, EL, ET, nuLT, GLT, GTT)
%LAMINATEABD Summary of this function goes here
%   Detailed explanation goes here

    nuTL = ET*nuLT/EL;
    
    Q11bar = EL/(1 - nuLT * nuTL);
    Q22bar = ET/(1 - nuLT * nuTL);
    Q12bar = nuTL * EL/(1 - nuLT * nuTL);
    
    Q21bar = Q12bar;
    Q44bar = GTT;
    Q55bar = GLT;
    Q66bar = GLT;
    
    U1 = 1/8 * (3 * Q11bar + 3 * Q22bar + 2*Q12bar + 4 * Q66bar);
    U2 = 1/2 * (Q11bar - 2 * Q22bar);
    U3 = 1/8 * (Q11bar + Q22bar - 2*Q12bar - 4 * Q66bar);
    U4 = 1/8 * (Q11bar + Q22bar + 6*Q12bar - 4 * Q66bar);
    U5 = 1/8 * (Q11bar + Q22bar - 2*Q12bar + 4 * Q66bar);
    
    U6 = 1/2 * (Q44bar + Q55bar);
    U7 = 1/2 * (Q44bar - Q55bar);
    
    A11 = 0;
    A12 = 0;
    A22 = 0;
    A16 = 0;
    A26 = 0;
    A66 = 0;
    
    B11 = 0;
    B12 = 0;
    B22 = 0;
    B16 = 0;
    B26 = 0;
    B66 = 0;
    
    D11 = 0;
    D12 = 0;
    D22 = 0;
    D16 = 0;
    D26 = 0;
    D66 = 0;
    
    A44 = 0;
    A45 = 0;
    A55 = 0;
    
    layerthickness = totalthickness / size(angles, 1);
    
    zk = -totalthickness/2;
    for i=1:size(angles, 1)
        theta = angles(i) * pi/180;
        Q11 = U1 + U2*cos(2*theta) + U3*cos(4*theta);
        Q22 = U1 - U2*cos(2*theta) + U3*cos(4*theta);
        Q12 = U4 - U3*cos(4*theta);
        Q66 = U5 - U3*cos(4*theta);

        Q16 = -1/2*U2*sin(2*theta) - U3*sin(4*theta);
        Q26 = -1/2*U2*sin(2*theta) + U3*sin(4*theta);

        Q44 = U6 + U7*cos(2*theta);
        Q55 = U6 - U7*cos(2*theta);

        Q45 = -U7 * cos(2*theta);
        
        dz = (zk + layerthickness) - zk;
        dz2 = (zk + layerthickness)^2 - zk^2;
        dz3 = (zk + layerthickness)^3 - zk^3;
        
        A11 = A11 + Q11 * dz;
        A12 = A12 + Q12 * dz;
        A22 = A22 + Q22 * dz;
        A16 = A16 + Q16 * dz;
        A26 = A26 + Q26 * dz;
        A66 = A66 + Q66 * dz;
        
        
        B11 = B11 + Q11 * dz2/2;
        B12 = B12 + Q12 * dz2/2;
        B22 = B22 + Q22 * dz2/2;
        B16 = B16 + Q16 * dz2/2;
        B26 = B26 + Q26 * dz2/2;
        B66 = B66 + Q66 * dz2/2;
        
        D11 = D11 + Q11 * dz3/3;
        D12 = D12 + Q12 * dz3/3;
        D22 = D22 + Q22 * dz3/3;
        D16 = D16 + Q16 * dz3/3;
        D26 = D26 + Q26 * dz3/3;
        D66 = D66 + Q66 * dz3/3;
        
        A44 = A44 + Q44 * dz * shearcorrectionfactor^2;
        A45 = A45 + Q45 * dz * shearcorrectionfactor^2;
        A55 = A55 + Q55 * dz * shearcorrectionfactor^2;
        
        zk = zk + layerthickness;
    end
    ABD = [A11, A12, A16, B11, B12, B16, 0, 0;
           A12, A22, A26, B12, B22, B26, 0, 0;
           A16, A26, A66, B16, B26, B66, 0, 0;
           B11, B12, B16, D11, D12, D16, 0, 0;
           B12, B22, B26, D12, D22, D26, 0, 0;
           B16, B26, B66, D16, D26, D66, 0, 0;
           0,    0,   0,   0,   0,   0,  A55, A45;
           0,    0,   0,   0,   0,   0,  A45, A44];
end

