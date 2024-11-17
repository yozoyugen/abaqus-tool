function abaqus_cylinder_inp(R, L, dR, dL)

% abaqus_cylinder_inp - Output Abaqus .inp file for cylinder shape structure 
%                    
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


	%printf("CYLI:");

	nElement = dR*2*dR*2*dL  
	nNode = (dR*2+1)*(dR*2+1)*(dL+1)

    elementmat = zeros(nElement, 8) ;
    coordmat = zeros(nNode, 3);

	dir1=1;
    dir2=2;
    dir3=3;
	% length1 = R*2;
	% length2 = R*2;
	% length3 = L;


	for j = 1 : dR*2+1   %( j = 0; j < dR*2+1; j++)  
	
		coordmat(j, dir1) = R*cos(-3.0/4.0*pi+pi/2.0/2.0/dR*(j-1) );
		coordmat(j, dir2) = R*sin(-3.0/4.0*pi+pi/2.0/2.0/dR*(j-1) );
		coordmat(j, dir3) = 0.0;

		coordmat( j+(dR*2+1)*dR*2, dir1) = R*cos(3.0/4.0*pi-pi/2.0/2.0/dR*(j-1));
		coordmat( j+(dR*2+1)*dR*2, dir2) = R*sin(3.0/4.0*pi-pi/2.0/2.0/dR*(j-1));
		coordmat( j+(dR*2+1)*dR*2, dir3) = 0.0;

    end

    %plot3( coordmat(1:(dR*2+1)*(dR*2+1),1), coordmat(1:(dR*2+1)*(dR*2+1),2),  coordmat(1:(dR*2+1)*(dR*2+1),3), 'o'   )
    %axis equal;

	for i = 2 : dR * 2 %(i = 1; i < dR*2; i++) 

		u1 = R*cos(-3.0/4.0*pi-pi/2.0/2.0/dR*(i-1));
		v1 = R*sin(-3.0/4.0*pi-pi/2.0/2.0/dR*(i-1));
        w1 = 0.0;

		u2 = 0.0;
		v2 = -R+R/dR*(i-1);
		w2 = 0.0;

		for j = 1 : dR  %(j = 0; j < dR; j++) 
			% coordmat( (dR*2+1)*(i-1)+j, dir1) = ( (dR-(j-1))*u1 + (j-1)*u2 )/dR;
			% coordmat( (dR*2+1)*(i)+1-j, dir1) = ( -(dR-(j-1))*u1 + (j-1)*u2 )/dR;
            % 
			% coordmat( (dR*2+1)*(i-1)+j, dir2) = ( (dR-(j-1))*v1 + (j-1)*v2 )/dR;
			% coordmat( (dR*2+1)*(i)+1-j, dir2) = ( (dR-(j-1))*v1 + (j-1)*v2 )/dR;
            % 
			% coordmat( (dR*2+1)*(i-1)+j, dir3) = ( (dR-(j-1))*w1 + (j-1)*w2 )/dR;
			% coordmat( (dR*2+1)*(i)+1-j, dir3) = ( (dR-(j-1))*w1 + (j-1)*w2 )/dR;

            

            coordmat( (dR*2+1)*(i-1)+j, dir1) = ( (dR-(j-1))*u1 )/dR;
			coordmat( (dR*2+1)*(i)+1-j, dir1) = ( -(dR-(j-1))*u1 )/dR;

            if j == 1
                v1 = R*sin(-3.0/4.0*pi-pi/2.0/2.0/dR*(i-1));
			    coordmat( (dR*2+1)*(i-1)+j, dir2) = ( (dR-(j-1))*v1 )/dR;
			    coordmat( (dR*2+1)*(i)+1-j, dir2) = ( (dR-(j-1))*v1 )/dR;
            else
                v1 = R*sin(-3.0/4.0*pi+pi/2.0/2.0/dR*(j-1));
                coordmat( (dR*2+1)*(i-1)+j, dir2) = ( (dR-(i-1))*v1 )/dR;
			    coordmat( (dR*2+1)*(i)+1-j, dir2) = ( (dR-(i-1))*v1 )/dR;
            end

			coordmat( (dR*2+1)*(i-1)+j, dir3) = ( (dR-(j-1))*w1 )/dR;
			coordmat( (dR*2+1)*(i)+1-j, dir3) = ( (dR-(j-1))*w1 )/dR;
        end

		coordmat( (dR*2+1)*(i-1)+dR+1, dir1) = u2;
		coordmat( (dR*2+1)*(i-1)+dR+1, dir2) = v2;
		coordmat( (dR*2+1)*(i-1)+dR+1, dir3) = w2;

    end

    %plot3( coordmat(1:(dR*2+1)*(dR*2+1),1), coordmat(1:(dR*2+1)*(dR*2+1),2),  coordmat(1:(dR*2+1)*(dR*2+1),3), 'o'   )
    %axis equal; 


	for k = 1 : dL  %(k = 1; k < dL+1; k++)
		for i = 1 : (dR*2+1)*(dR*2+1)  %(i = 0; i < (dR*2+1)*(dR*2+1); i++)
			coordmat( (i+(dR*2+1)*(dR*2+1)*k), dir1) = coordmat(i, dir1);
			coordmat( (i+(dR*2+1)*(dR*2+1)*k), dir2) = coordmat(i, dir2);
			coordmat( (i+(dR*2+1)*(dR*2+1)*k), dir3) = L/dL*k;
        end
    end


    % plot3( coordmat(:,1), coordmat(:,2),  coordmat(:,3), 'o'   )
    % axis equal; 
    % hold on;
    % for i = 1 : nNode
    %     text(coordmat(i,1), coordmat(i,2), coordmat(i,3), sprintf('#%d', i) );
    % end


	for i = 1 : dR*2  %(i = 0; i < dR*2; i++)
	
		elementmat(i, 1) = i + (dR*2+1)*(dR*2+1);
		elementmat(i, 2) = i;
		elementmat(i, 3) = i + (dR*2+1);
		elementmat(i, 4) = i + (dR*2+1)+(dR*2+1)*(dR*2+1);

		elementmat(i, 5) = elementmat(i, 1) + 1;
		elementmat(i, 6) = elementmat(i, 2) + 1;
		elementmat(i, 7) = elementmat(i, 3) + 1;
		elementmat(i, 8) = elementmat(i, 4) + 1;		
	
    end
    %elementmat


    for j = 2 : dR*2  %(j = 1; j < dR*2; j++) 
		for i = 1 : dR*2 %(i = 0; i < dR*2; i++) 
			for jj = 1 : 8 %(jj = 0; jj < 8; jj++) //			
				%elementmat((i+j*dR*2)*8+jj]=elementmat(i*8+jj]+(dR*2+1)*j;
                elementmat( (i+(j-1)*dR*2), jj) = elementmat(i, jj) + (dR*2+1)*(j-1);
            end
        end
    end
    %elementmat

	for k = 2 : dL %(k = 1; k < dL; k++) 
		for i = 1 : (dR*2)*(dR*2) %(i = 0; i < (dR*2)*(dR*2); i++) 
			for jj = 1 : 8 %(jj = 0; jj < 8; jj++) 
			
				%elementmat((i+k*(dR*2)*(dR*2))*8+jj]=elementmat(i*8+jj]+(dR*2+1)*(dR*2+1)*k;
                elementmat(i+(k-1)*(dR*2)*(dR*2), jj) = elementmat(i, jj) + (dR*2+1)*(dR*2+1)*(k-1);

            end
        end
    end
	

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


    drawElement(coordmat', elementmat', 0)

end