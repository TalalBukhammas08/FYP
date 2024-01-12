// Gmsh project created on Thu Dec 22 15:01:27 2022
SetFactory("OpenCASCADE");
gridsize = 1/300;
//+
Point(1) = {0, 0, 0, 1.0};
//+
Point(2) = {1, 0, 0, 1.0};
//+
Point(3) = {1, 1, 0, 1.0};
//+
Point(4) = {0, 1, 0, 1.0};
//+
Line(5) = {1, 2};
Line(6) = {2, 3};
Line(7) = {3, 4};
Line(8) = {4, 1};

//+
Circle(9) = {0.5, 0.5, 0, 0.1, 0, 2*Pi};

Curve Loop(10) = {5, 6, 7, 8};
Curve Loop(11) = 9;
Plane Surface(12) = {10, 11};

Transfinite Line{5, 6, 7, 8} = 1/gridsize;
Recombine Surface{12};//+
Physical Curve("Supported", 13) = {8, 7, 6, 5};
//+
Physical Surface("Elements", 14) = {12};
