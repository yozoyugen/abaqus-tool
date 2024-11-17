function abaqus_plate_inp(Lx, Ly, Lz, dx, dy, dz)

% abaqus_plate_inp - Output Abaqus .inp file for plate shape structure 
%                    with fixed boundary contidions
% Copyright (c) 2024 Yozo Yugen
% 
% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the License, or any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program. If not, see http://www.gnu.org/licenses/.


    % z: thickness direction

    nNode = (dx+1) * (dy+1) * (dz+1);
    coordmat = zeros(nNode, 3);

    for x = 1 : dx+1
        for y = 1 : dy+1
            for z = 1 : dz+1
                i = (x-1)*(dy+1)*(dz+1) + (y-1)*(dz+1) + z ;
                coordmat( i , : ) = [ Lx / dx * (x-1)    Ly / dy * (y-1)    Lz / dz * (z-1) ] ;
            end
        end
    end

    % close all
    % fig1 = figure(1);
    % plot3(coordmat(:,1), coordmat(:,2), coordmat(:,3), 'bo' );
    % xlabel('X');
    % ylabel('Y');
    % zlabel('Z');
    % axis equal;
    % 
    % for i = 1 : nNode
    %     text(coordmat(i,1), coordmat(i,2), coordmat(i,3), sprintf('#%d', i) );
    % end


    nElement = dx * dy * dz ;
    elementmat = zeros(nElement, 8) ;
    for x = 1 : dx
        for y = 1 : dy
            for z = 1 : dz
                n1 = (x - 1) * (dy+1) * (dz+1) + (y - 1) * (dz+1) + z ;
                n2 = n1 + (dy+1) * (dz+1) ;
                n3 = n2 + (dz+1) ;
                n4 = n1 + (dz+1) ;
                n5 = n1 + 1 ;
                n6 = n2 + 1 ;
                n7 = n3 + 1 ;
                n8 = n4 + 1 ;
                 i = (x - 1) * dy * dz + (y -1) * dz + z;
                elementmat(i, :) = [n1 n2 n3 n4 n5 n6 n7 n8];
            end
        end
    end


    a = [];
    tol = 1E-10;
    for i = 1 : nNode
        
        if abs(0.0 - coordmat(i,1) ) < tol
            a=[a i]; 
        elseif abs(Lx - coordmat(i,1) ) < tol
            a=[a i];
        elseif abs(0.0 - coordmat(i,2) ) < tol
            a=[a i]; 
        elseif abs(Ly - coordmat(i,2) ) < tol
            a=[a i];
        end    
    
    end
    
    a = unique(a);

    coordmat(:,1) = coordmat(:,1) - Lx/2;
    coordmat(:,2) = coordmat(:,2) - Ly/2;


    fileID = fopen('temp_node.inp','w');

    fprintf(fileID,'*Node\n');
    for i = 1 : nNode
        fprintf(fileID, '%d, %.6e, %.6e, %.6e\n', i, coordmat(i,1), coordmat(i,2), coordmat(i,3) ) ;
    end
    fclose(fileID);


    fileID = fopen('temp_element.inp','w');

    fprintf(fileID,'*Element, type=C3D8R\n' );
    for i = 1 : nElement
        fprintf(fileID, '%d, %d, %d, %d, %d, %d, %d, %d, %d\n', i, elementmat(i,1), elementmat(i,2), elementmat(i,3), elementmat(i,4), elementmat(i,5), elementmat(i,6), elementmat(i,7), elementmat(i,8)  ) ;
    end
    fclose(fileID);

    %fprintf(fileID,'**\n' );
    

    fileID = fopen('temp_nset.inp','w');

    fprintf(fileID,'*Nset, nset=Set-1, instance=plate-1\n' );
    for i = 1 : length(a)
        fprintf(fileID, '%d, ', a(i));
        if rem(i,20) == 0
            fprintf(fileID, '\n');
        end
    end
    fprintf(fileID, '\n');
    fprintf(fileID,'**\n' );

    %Set-1, ENCASTRE
    fprintf(fileID,'*Boundary\n' );
    fprintf(fileID,'Set-1, ENCASTRE\n' );

    fclose(fileID);


    drawElement(coordmat', elementmat',0)
    %drawElement(coordmat', elementmat',1)
    fprintf('Nodes:%d, Elements:%d\n', nNode, nElement)

end