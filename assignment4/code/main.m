clear; close all; clc;

% specify the path of vl_feat
run('/home/mars/Documents/Yang_files/vlfeat-0.9.21/toolbox/vl_setup.m');

Ia = imread('pics/northrop_left.jpg');
Ib = imread('pics/northrop_right.jpg');

% SIFT Feature Extraction and Visualization
% SIFT_visualization(Ia,500);
% SIFT_visualization(Ib,500);


%% SIFT Feature Matching

% nearest neighbor search
% [matches_a,matches_b] = knn_match(Ia,Ib);
% idxn = 1:30:size(matches_a,1);
% matching_visualization(Ia,Ib,matches_a(idxn,:),matches_b(idxn,:));
% [matches_b,matches_a] = knn_match(Ib,Ia);
% matching_visualization(Ia,Ib,matches_a(idxn,:),matches_b(idxn,:));

% ratio test
% [matches_a,matches_b] = ratio_match(Ia,Ib,0.7);
% matching_visualization(Ia,Ib,matches_a,matches_b);
% [matches_b,matches_a] = ratio_match(Ib,Ia,0.7);
% matching_visualization(Ia,Ib,matches_a,matches_b);

% bidirectional match
% [matches_a,matches_b] = bidirectional_match(Ia,Ib,0.7);
% matching_visualization(Ia,Ib,matches_a,matches_b);


%% Fundamental matrix

% rand_8int = randi([1 size(matches_a,1)],1,8);
% u = matches_a(rand_8int,:);
% v = matches_b(rand_8int,:);
% 
% F = ComputeFundamentalMatrix(u, v);
% 
% % epipole and epipolar line
% epipo_visualization(F,Ia,Ib);


%% Robust Fundamental Matrix Estimation

% ransac
% [u,v] = bidirectional_match(Ia,Ib,0.7);
% [F,inliers] = RansacFundamentalMatrix(u,v);
% u_in = u(inliers,:);
% v_in = v(inliers,:);
% matching_visualization(Ia,Ib,u_in,v_in);

% epipole and epipolar line
% epipo_visualization(F,Ia,Ib);

% camera pose estimation
% f = 3351.6;
% px = size(Ia,2)/2;
% py = size(Ia,1)/2;
% K = [f 0 px; 0 f py; 0 0 1];
% R = eye(3);
% t = zeros(3,1);
% [R1 t1 R2 t2 R3 t3 R4 t4] = CameraPose(F, K);
% Rs = zeros(3,3,4);
% Rs(:,:,1) = R1;
% Rs(:,:,2) = R2;
% Rs(:,:,3) = R3;
% Rs(:,:,4) = R4;
% ts = zeros(3,4);
% ts(:,1) = t1;
% ts(:,2) = t2;
% ts(:,3) = t3;
% ts(:,4) = t4;
% Cs = zeros(3,4);
% Cs(:,1) = -R1'*t1;
% Cs(:,2) = -R2'*t2;
% Cs(:,3) = -R3'*t3;
% Cs(:,4) = -R4'*t4;

% % visualize R and C
% figure();
% subplot(2,2,1);
% DisplayCamera(t, R, 0.3);
% hold on;
% DisplayCamera(Cs(:,1), R1, 0.3);
% subplot(2,2,2);
% DisplayCamera(t, R, 0.3);
% hold on;
% DisplayCamera(Cs(:,2), R2, 0.3);
% subplot(2,2,3);
% DisplayCamera(t, R, 0.3);
% hold on;
% DisplayCamera(Cs(:,3), R3, 0.3);
% subplot(2,2,4);
% DisplayCamera(t, R, 0.3);
% hold on;
% DisplayCamera(Cs(:,4), R4, 0.3);


%% Triangulation

% linear triangulation
% function LinearTriangulation

% cheirality
% function CheckCheirality

% camera pose disambiguation
% maxValid = 0;
% P1 = K*[R t];
% for i = 1:4
%     P2 = K*[Rs(:,:,i) ts(:,i)];
%     
%     for j = 1 : size(u_in,1)
%         Y(j,:) = LinearTriangulation(P1,u_in(j,:),P2,v_in(j,:));
%     end
%     
%     if size(CheckCheirality(Y,t,R,Cs(:,i),Rs(:,:,i)),1) > maxValid
%     
%         R_s = Rs(:,:,i);
%         t_s = ts(:,i);
%         Y_s = Y;
%         maxValid = size(CheckCheirality(Y_s,t,R,Cs(:,i),Rs(:,:,i)),1);
%         idx = i;
%         
%     end
%    
%     figure();
%     plot3(Y(:,1), Y(:,2), Y(:,3), 'b.');
%     hold on
%     DisplayCamera(t, R, 200);
%     hold on
%     DisplayCamera(-Rs(:,:,i)'*Cs(:,i), Rs(:,:,i)', 200);
%     
% end

%reprojection
% u_tl = K*R*[eye(3) t]*[Y_s';ones(1,size(Y_s,1))];
% u_tl = u_tl(1:2,:)./u_tl(3,:);
% u_tl = u_tl';
% figure();
% imshow(Ia);
% hold on;
% scatter(u_in(:,1),u_in(:,2),'b','o');
% hold on;
% scatter(u_tl(:,1),u_tl(:,2),'r','x');
% 
% v_tl = K*[R_s t_s]*[Y_s';ones(1,size(Y_s,1))];
% v_tl = v_tl(1:2,:)./v_tl(3,:);
% v_tl = v_tl';
% figure();
% imshow(Ib);
% hold on;
% scatter(v_in(:,1),v_in(:,2),'b','o');
% hold on;
% scatter(v_tl(:,1),v_tl(:,2),'r','x');



