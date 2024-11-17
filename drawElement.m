function drawElement(coordmat, elementmat, flag_text)

% HAKAI - A 3-dimensional finite element program
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


    coordmat = coordmat'; % row major
    elementmat = elementmat'; % row major

    figure

    nNode = size(coordmat,1);
    %plot3(coordmat(:,1), coordmat(:,2), coordmat(:,3), 'bo' );
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    axis equal;
    hold on;

    if flag_text == 1
        plot3(coordmat(:,1), coordmat(:,2), coordmat(:,3), 'bo' );
        for i = 1 : nNode
            text(coordmat(i,1), coordmat(i,2), coordmat(i,3), sprintf('#%d', i) );
        end
    end


    nElement = size(elementmat,1);
    nEN = size(elementmat,2);

    drawMat1x = zeros(5,nElement*2);
    drawMat1y = zeros(5,nElement*2);
    drawMat1z = zeros(5,nElement*2);

    drawMat2x = zeros(2,nElement*4);
    drawMat2y = zeros(2,nElement*4);
    drawMat2z = zeros(2,nElement*4);

    if nEN == 8
       
        % for i = 1 : nElement
        %     nd = elementmat(i,:);
        %     ii = nd([1 2 3 4 1]);
        %     line( coordmat( ii,1),  coordmat( ii,2), coordmat( ii,3), 'color', 'b' )
        %     ii = nd([5 6 7 8 5]);
        %     line( coordmat( ii,1),  coordmat( ii,2), coordmat( ii,3), 'color','b' )
        %     ii = nd([1 5]);
        %     line( coordmat( ii,1),  coordmat( ii,2), coordmat( ii,3), 'color','b' )
        %     ii = nd([2 6]);
        %     line( coordmat( ii,1),  coordmat( ii,2), coordmat( ii,3), 'color','b' )
        %     ii = nd([3 7]);
        %     line( coordmat( ii,1),  coordmat( ii,2), coordmat( ii,3), 'color','b' )
        %     ii = nd([4 8]);
        %     line( coordmat( ii,1),  coordmat( ii,2), coordmat( ii,3), 'color','b' )
        % end

        for i = 1 : nElement
             nd = elementmat(i,:);

             ii = nd([1 2 3 4 1]);
                drawMat1x(:,i*2-1) = coordmat(ii,1);
                drawMat1y(:,i*2-1) = coordmat(ii,2);
                drawMat1z(:,i*2-1) = coordmat(ii,3);
             ii = nd([5 6 7 8 5]);
                drawMat1x(:,i*2) = coordmat(ii,1);
                drawMat1y(:,i*2) = coordmat(ii,2);
                drawMat1z(:,i*2) = coordmat(ii,3);

             ii = nd([1 5]);
                drawMat2x(:,i*4-3) = coordmat(ii,1);
                drawMat2y(:,i*4-3) = coordmat(ii,2);
                drawMat2z(:,i*4-3) = coordmat(ii,3);
             ii = nd([2 6]);
                drawMat2x(:,i*4-2) = coordmat(ii,1);
                drawMat2y(:,i*4-2) = coordmat(ii,2);
                drawMat2z(:,i*4-2) = coordmat(ii,3);
             ii = nd([3 7]);
                drawMat2x(:,i*4-1) = coordmat(ii,1);
                drawMat2y(:,i*4-1) = coordmat(ii,2);
                drawMat2z(:,i*4-1) = coordmat(ii,3);
             ii = nd([4 8]);
                drawMat2x(:,i*4) = coordmat(ii,1);
                drawMat2y(:,i*4) = coordmat(ii,2);
                drawMat2z(:,i*4) = coordmat(ii,3);

        end

        line( drawMat1x,  drawMat1y, drawMat1z, 'color', 'b' )
        line( drawMat2x,  drawMat2y, drawMat2z, 'color', 'b' )

    elseif nEN == 4

        for i = 1 : nElement
            nd = elementmat(i,:);
            ii = nd([1 2 3 4 1]);
            line( coordmat( ii,1),  coordmat( ii,2), coordmat( ii,3), 'color', 'b' )
        end
        
    end

end
