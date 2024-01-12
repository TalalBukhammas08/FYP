function [nodes, elements] = processmeshfile(filepath)
%PROCESSMESHFILE Outputs nodes and elements vectors from file
%   nodes: x, y, z, BC
%   elements: node1, node2, node3, node4, material, temperature
    %File
    fileID = fopen(filepath, 'r');
    
    
    %% LOOP THROUGH THE LINES OF THE FILE
    while(true)
        line = fgetl(fileID);
        if(line == -1)
            break; 
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
                end
            end
        end
        
    end
    %Close the file for efficiency
    fclose(fileID);
    elements = elements(any(elements,2),:);
%     disp(supportedphysicalid);
%     disp(elementsphysicalid);
end

