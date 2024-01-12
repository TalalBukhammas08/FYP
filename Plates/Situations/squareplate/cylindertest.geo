// Gmsh project created on Sat Jan 28 23:18:15 2023
SetFactory("OpenCASCADE");//+
Rectangle(1) = {0, 0.25, 0, 1, 0.5, 0};
//+
Curve Loop(2) = {3, 4, 1, 2};
//+
Plane Surface(2) = {2};