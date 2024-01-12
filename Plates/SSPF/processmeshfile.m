function [nodes, elements] = processmeshfile(filepath)
%PROCESSMESHFILE Outputs nodes and elements vectors from file
%   nodes: x, y, z, BC
%   elements: node1, node2, node3, node4, material
    %File
    fileID = fopen(filepath, 'r');
    
    %Mesh properties
    nphysicalids = -1;
    supportedphysicalid = -1;
    elementsphysicalid = -1;
    numberofnodes = -1;
    numberofelements = -1;
    
    %% LOOP THROUGH THE LINES OF THE FILE
    while(true)
        line = fgetl(fileID);
        if(line == -1)
            break; 
        end
        
        %Get the physicalname IDS
        if(line == "$PhysicalNames")
            nphysicalids = str2double(fgetl(fileID));
            while(true)
                line = fgetl(fileID);
                
                if(line == "$EndPhysicalNames")
                   break;
                else
                    separation = strsplit(line);
                    if(separation(3) == strcat('"', "Supported", '"'))
                       supportedphysicalid = str2double(separation(2)); 
                    elseif(separation(3) == strcat('"', "Elements", '"'))
                        elementsphysicalid = str2double(separation(2)); 
                    end
                end

            end
        end
        
        %Get the nodes
        if(line == "$Nodes")
            numberofnodes = str2double(fgetl(fileID));
            %Initialise node matrix
            nodes = zeros(numberofnodes, 4);
            while(true)
                line = fgetl(fileID);
                if(line == "$EndNodes")
                   break;
                else
                    separation = strsplit(line);
                    nodes(str2double(separation(1)), 1:3) = str2double(separation(2:4));
                end

            end
        end
        
        %Get the elements
        if(line == "$Elements")
            numberofelements = str2double(fgetl(fileID));
            %Initialise node matrix
            elements = zeros(numberofelements, 9);
            while(true)
                line = fgetl(fileID);
                try
                if(line == "$EndElements")
                   break;
                else
                    separation = strsplit(line);
                    elements(str2double(separation(1)), 1:8) = str2double(separation(6:13));
                    elements(str2double(separation(1)), 9) = 1;
                end
                catch
%                    warning("Input elements format not as expected! Check if there are triangular elements in the mesh"); 
                end
            end
        end
        
    end
    %Close the file for efficiency
    fclose(fileID);
    
    %% ERROR TESTING
%     if(supportedphysicalid == -1)
%        warning("Support BCs not set.");
%     end
%     if(elementsphysicalid == -1)
%         warning("Element BCs not set.");
%     end
%     if(numberofnodes == -1)
%         warning("Number of nodes not found.");
%     end
%     if(numberofelements == -1)
%         warning("Number of elements not found.");
%     end
    elements = elements(any(elements,2),:);
%     disp(supportedphysicalid);
%     disp(elementsphysicalid);
end

