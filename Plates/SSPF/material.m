classdef material
    %MATERIAL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        E %Young's Modulus (Pa)
        G %Shear Modulus
        thickness; %(m)
        nu; %Poisson's ratio
        alpha; %Shear correction factor
        density; %Density
    end
    
    methods
        function obj = material(E, thickness, nu, alpha, density)
            %MATERIAL Construct an instance of this class
            %   Detailed explanation goes here
            obj.E = E;
            obj.nu = nu;
            obj.G = E / (2 * (nu + 1));
            obj.thickness = thickness;
            obj.alpha = alpha;
            obj.density = density;
        end
    end
end

