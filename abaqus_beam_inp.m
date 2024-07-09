function abaqus_beam_inp(Lx, Ly, Lz, dx, dy, dz, F)

    % Lx = 8.0;
    % Ly = 1.0;
    % Lz = 1.0;
    % dx = 32;
    % dy = 4;
    % dz = 4;
    % F = -8;

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

    close all
    fig1 = figure(1);
    plot3(coordmat(:,1), coordmat(:,2), coordmat(:,3), 'bo' );
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    axis equal;

    for i = 1 : nNode
        text(coordmat(i,1), coordmat(i,2), coordmat(i,3), sprintf('#%d', i) );
    end

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

    fileID = fopen('samp.inp','w');

    fprintf(fileID,'*node\n');

    for i = 1 : nNode
        fprintf(fileID, '%d, %.3f, %.3f, %.3f\n', i, coordmat(i,1), coordmat(i,2), coordmat(i,3) ) ;
    end
    
    fprintf(fileID,'*element, type=C3D8, elset=elems\n' );

    for i = 1 : nElement
        fprintf(fileID, '%d, %d, %d, %d, %d, %d, %d, %d, %d\n', i, elementmat(i,1), elementmat(i,2), elementmat(i,3), elementmat(i,4), elementmat(i,5), elementmat(i,6), elementmat(i,7), elementmat(i,8)  ) ;
    end
    
    fprintf(fileID,'*material, name=mat\n' );
    fprintf(fileID,'*elastic\n' );
    fprintf(fileID,'205000, 0.3\n' );
    % fprintf(fileID,'*plastic\n' );
    % fprintf(fileID,'245, 0.0\n' );
    % fprintf(fileID,'265, 0.1\n' );
    % fprintf(fileID,'285, 0.3\n' );
    % fprintf(fileID,'300, 1.0\n' );
    
    fprintf(fileID,'*solid section, material=mat, elset=elems\n' );

    fprintf(fileID,'*boundary\n' );
    for i = 1 : (dy + 1) * (dz + 1)
        fprintf(fileID,'%d, 1, 3\n', i );
    end
    
    fprintf(fileID,'*step\n' );
    fprintf(fileID,'*static, direct\n' );
    fprintf(fileID,'1.0, 1.0\n' );
    
    fprintf(fileID,'*cload\n' );
    for i = 1 : (dy + 1) * (dz + 1)
        j = i + (dy + 1) * (dz + 1) * dx ;
        fprintf(fileID,'%d, 2, %.3f\n', j,  F / (dy + 1) / (dz + 1) );
    end

    fprintf(fileID,'*matrix generate, stiffness\n' );
    fprintf(fileID,'*element matrix output, elset=elems, stiffness=yes, outputfile=user\n' );


    fprintf(fileID,'*end step\n');
    
    fclose(fileID);

end