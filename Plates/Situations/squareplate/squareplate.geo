// Gmsh project created on Fri Dec 23 19:47:13 2022
SetFactory("OpenCASCADE");
gridsize = 1/21;
//+
Point(1) = {0, 0, 0, 1.0};
//+
Point(2) = {1, 0, 0, 1.0};
//+
Point(3) = {1, 1, 0, 1.0};
//+
Point(4) = {0, 1, 0, 1.0};
//+
Line(1) = {1, 2};
//+
Line(2) = {2, 3};
//+
Line(3) = {3, 4};
//+
Line(4) = {4, 1};
//+
Curve Loop(1) = {3, 4, 1, 2};
//+
Plane Surface(1) = {1};

Mesh.ElementOrder = 2;
Mesh.SecondOrderIncomplete = 1;

Transfinite Line{1, 2, 3, 4} = 1 / gridsize;
Transfinite Surface{1};
Recombine Surface{1};