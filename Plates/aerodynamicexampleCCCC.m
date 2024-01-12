close all; 
clear all;
clc;


[nodes, elements] = processmeshfile('Situations/squareplate/squareplate-highres.msh');
% nodes = supportedbccircularplate(nodes);
nodes = supportedbcsquareplate(nodes);
nodes(:, 4) = nodes(:, 4) * 2;

% figure();
% hold on;
% set(gcf, 'WindowState', 'maximized');
% view(45, 45);
% plotmesh(nodes, elements);
% 
% axis([0, 1, 0, 1, 0, 1]);
% axis([0, 0.3, 0, 0.3, 0, 0.3]);
% 
% daspect([1, 1, 1]);
% xlabel('x');
% ylabel('y');
% zlabel('z');
% 
% hold off;

m = material(71.7*10^9 , 1/1000, 0.3, 5/6, 2810);


[bcvector] = calculatebcvector(nodes);
[K] = assembleglobalstiffnessmatrix(m, bcvector, nodes, elements);
K = (K + K')/2;

[M] = assembleglobalmassmatrix(m, bcvector, nodes, elements);

M = (M + M')/2;

Ka = assembleglobalaerodynamicmatrix(bcvector, nodes, elements);

numberofmodes = 100;
[psi, b] = eigs(K, M, numberofmodes, 'smallestabs');
for i=1:size(psi, 2)
   nf = sqrt(psi(:, i).' * M * psi(:, i));
   psi(:, i) = psi(:, i).' / nf;
end

eigendiagonal = b;

min_lambda_dimensionless = 851.4;
max_lambda_dimensionless = 853;

n_tests = 100;
lambdas = [];


lambda_dimensionless = min_lambda_dimensionless:(max_lambda_dimensionless-min_lambda_dimensionless)/n_tests:max_lambda_dimensionless;
lambda_dimensionless = lambda_dimensionless.';

complex_eigenvalue = [];
real_eigenvalue = [];

reduced = psi.' * Ka * psi;

tic;
for loop=1:size(lambda_dimensionless, 1)
    
    lambda = lambda_dimensionless(loop) / ((1000/1000)^3 / (m.E * m.thickness^3/(12 * (1 - m.nu^2))));
    
    disp(['i: ', num2str(loop), 'lambda_dimensionless: ', num2str(lambda_dimensionless(loop))]);
    
    [a, b] = eig((eigendiagonal + lambda * reduced));
    
    if(~isreal(b))
        disp(lambda_dimensionless(loop));
        D = m.E * m.thickness^3 / (12 * (1 - m.nu^2));
        omega_dimensionless = real(b) .* sign(imag(b)) * m.density * m.thickness * 1^4/D;
        break;
    end
end
toc