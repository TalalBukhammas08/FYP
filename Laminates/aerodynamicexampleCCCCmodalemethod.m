close all; 
clear all;
clc;


[nodes, elements] = processmeshfile('Situations/squareplate/squareplate10x10.msh');
% nodes = supportedbccircularplate(nodes);
nodes = supportedbcsquareplate(nodes);

shearcorrectionfactor = 5/6;

angles = [0;90;0;90;0;90];
angles = [0;90;0;90];

totalthickness = 0.01;

EL = 62*10^9;
ET = 24.8 * 10^9;
GLT = 17.38 * 10^9;
GTT = GLT;

nuLT = 0.23;
density = 2000;

[ABD] = laminateabd(shearcorrectionfactor, angles, totalthickness, EL, ET, nuLT, GLT, GTT);
[refABD] = laminateabd(shearcorrectionfactor, [0;0;0], totalthickness, EL, ET, nuLT, GLT, GTT);
D110 = refABD(4, 4);

[bcvector] = calculatebcvector(nodes);
disp('Assembling K');
tic;
[K] = assembleglobalstiffnessmatrixdof(bcvector, nodes, elements, ABD, 5);
toc
K = (K + K')/2;
disp('Assembling M');
tic;
[M] = assembleglobalmassmatrixdof(totalthickness, density, bcvector, nodes, elements, 5);
toc
M = (M + M')/2;

Ka = assembleglobalaerodynamicmatrixdof(bcvector, nodes, elements, 5);


numberofmodes = 50;
[psi, b] = eigs(K, M, numberofmodes, 'smallestabs');

for i=1:size(psi, 2)
   nf = sqrt(psi(:, i).' * M * psi(:, i));
   psi(:, i) = psi(:, i).' / nf;
end
eigendiagonal = b;


figure();
hold on;
set(gcf, 'WindowState', 'maximized');

min_lambda_dimensionless = 300;
max_lambda_dimensionless = 370;

n_tests = 100;
lambdas = [];


lambda_dimensionless = min_lambda_dimensionless:(max_lambda_dimensionless-min_lambda_dimensionless)/n_tests:max_lambda_dimensionless;
lambda_dimensionless = lambda_dimensionless.';

complex_eigenvalue = [];
real_eigenvalue = [];

for loop=1:size(lambda_dimensionless, 1)
    
    D = (EL * totalthickness^3 / (12 * (1- nuLT * ET*nuLT/EL)));
    lambda = lambda_dimensionless(loop) /( 1^3 / D);
    
    reduced = psi.' * Ka * psi;
    
    [a, b] = eigs((eigendiagonal + lambda * reduced), 50, 'smallestabs');
    
    disp(['i: ' num2str(loop) ' lambda_dimensionless: ' num2str(lambda_dimensionless(loop))]);
    if(~isreal(b))
        disp(lambda_dimensionless(loop));
        
        omega_cr_dimensionless = real(b) * density * totalthickness * 1^4/ (D);
        omega_cr_dimensionless = omega_cr_dimensionless .* sign(imag(b));
        break;
    end    
end