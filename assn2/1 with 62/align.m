function out = align(im1,im2,Xs,Ys,Xp,Yp)
out = im2;
imgIn = im1;
imgIout = im2;
%%--------------------------------------------------
%     NPs = input('Enter number of landmark points : ');
%     fprintf('Select %d correspondence / landmark points with mouse on Fig.2.\n',NPs);
% 
%     figure(2);
%     Hp=subplot(1,2,1); % for landmark point selection
%     image(imgIn);
%     %colormap(map);
%     colormap default;
%     hold on;
%     
%     Hs=subplot(1,2,2); % for correspondence point selection
%     imagesc(imgIout);
%     %colormap(map);
%     colormap default;
%     hold on;
%     
%     Xp=[]; Yp=[]; Xs=[]; Ys=[];
%     for ix = 1:NPs
%         axis(Hp);
%         %EXAMPLE IMAGE
%         [Yp(ix),Xp(ix)]=ginput(1); % get the landmark point
%         scatter(Yp(ix),Xp(ix),32,'y','o','filled'); % display the point
%         text(Yp(ix),Xp(ix),num2str(ix),'FontSize',6);
%         
%         axis(Hs);
%         %INPUT IMAGE (WITHOUT MAKEUP)
%         [Ys(ix),Xs(ix)]=ginput(1); % get the corresponding point
%         scatter(Ys(ix),Xs(ix),32,'y','*'); % display the point
%         text(Ys(ix),Xs(ix),num2str(ix),'FontSize',6);
%     end
%%--------------------------------------------------
keyboard
[~, l] = size(Xs);

Xss = reshape(Xs,[l,1]);
Yss = reshape(Ys,[l,1]);
T = delaunayTriangulation(Xss,Yss);


Xpp = reshape(Xp,[l,1]);
Ypp = reshape(Yp,[l,1]);
T2 = delaunayTriangulation(Xpp,Ypp);  

T3 = triangulation(T.ConnectivityList,T2.Points);

[s,~] = size(T);
%keyboard;
for h=1:s
    disp(h);
    
    n1 = T.ConnectivityList(h,1);
    n2 = T.ConnectivityList(h,2);
    n3 = T.ConnectivityList(h,3);
    x1 = [T.Points(n1,1),T.Points(n2,1),T.Points(n3,1)];
    y1 = [T.Points(n1,2),T.Points(n2,2),T.Points(n3,2)];
    
    i_min=10000;
    i_max=0;
    j_min=10000;
    j_max=0;
    for i=1:3
        if (x1(i)<i_min)
            i_min = x1(i);
        end
        if (x1(i)>i_max)
            i_max = x1(i);
        end
        if (y1(i)<j_min)
            j_min = y1(i);
        end
        if (y1(i)>j_max)
            j_max = y1(i);
        end
    end
    i_min = floor(i_min);
    i_max = floor(i_max)+1;
    j_min = floor(j_min);
    j_max = floor(j_max)+1;
    for i=i_min:i_max
        for j=j_min:j_max
            PC = [i,j];
            B = cartesianToBarycentric(T,h,PC);            
            if ((B(1)>=0)&&(B(2)>=0)&&(B(3)>=0))  
                PC = barycentricToCartesian(T3,h,B);
                p = floor(PC(1));
                q = floor(PC(2));
                out(i,j,:) = im1(p,q,:);
            end
        end
    end
    
end
figure, imshow(out), title('out');
%keyboard;
end

