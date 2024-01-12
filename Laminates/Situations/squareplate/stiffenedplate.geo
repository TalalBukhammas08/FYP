// Gmsh project created on Wed Mar 01 16:01:40 2023
SetFactory("OpenCASCADE");
a1 = 75/1000;
a2 = 10.5 / (2 * 1000);

//+
Point(1) = {0, 0, 0, 1.0};
//+
Point(2) = {0, a1*2, 0, 1.0};
//+
Point(3) = {a1, a1*2, 0, 1.0};
//+
Point(4) = {a1, 0, 0, 1.0};


//+
Point(5) = {a1*2, 0, 0, 1.0};
//+
Point(6) = {a1*2, a1*2, 0, 1.0};
//+
Line(1) = {1, 2};
//+
Line(2) = {2, 3};
//+
Line(3) = {3, 4};
//+
Line(4) = {4, 1};
//+
Line(5) = {4, 5};
//+
Line(6) = {5, 6};
//+
Line(7) = {4, 3};
//+
Line(8) = {6, 3};
//+
Curve Loop(1) = {1, 2, 3, 4};
//+
Plane Surface(1) = {1};
//+
Curve Loop(2) = {8, 3, 5, 6};
//+
Plane Surface(2) = {2};

//+
Point(7) = {a1, a1*2, -a2*2, 1.0};
//+
Point(8) = {a1, 0, -a2*2, 1.0};//+
Line(9) = {4, 8};
//+
Line(10) = {8, 7};
//+
Line(11) = {7, 3};
//+
Curve Loop(3) = {9, 10, 11, 3};
Plane Surface(3) = {3};


Mesh.ElementOrder = 2;
Mesh.SecondOrderIncomplete = 1;