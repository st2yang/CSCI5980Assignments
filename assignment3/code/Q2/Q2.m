% Rotation Interpolation
% note: quaternion in this file is with JPL standard

clear; close all; clc;
mkdir generated_pics;

im1 = imread('Q2_left.jpg');
im2 = imread('Q2_right.jpg');

f = 3351.6;
px = size(im1,2)/2;
py = size(im1,1)/2;
K = [f 0 px; 0 f py; 0 0 1];


% np = 4;
% % choose matched feature
% imshow(im1);
% zoom on;
% waitfor(gcf, 'CurrentCharacter', char(13))
% zoom reset;
% zoom off;
% [x1,y1] = ginput(np);
% close;
% u1 = [x1 y1 ones(np,1)];
% 
% imshow(im2);
% zoom on;
% waitfor(gcf, 'CurrentCharacter', char(13))
% zoom reset;
% zoom off;
% [x2,y2] = ginput(np);
% close;
% u2 = [x2 y2 ones(np,1)];
load('u1.mat');load('u2.mat');


% compute homography
H = ComputeHomography(u1, u2);

% compute rotation
H = H/H(3,3);
R = inv(K) * H * K;
detR = det(R);
R = 1/detR^(1/3) * R;


% interpolation
N = 10;
q1 = [0;0;0;1];
q2 = rot2quat(R);
omega = acos(q1'*q2);
w = (0:0.05:1)';
im_temp = zeros(3024,4032,3);

for i = 1:size(w,1)
    
    p = (q1*sin((1-w(i,1))*omega)+q2*sin(w(i,1)*omega))/sin(omega);
    i_Rset_l = transpose(quat2rot(p));
    i_Hset_l = K*i_Rset_l*inv(K);
    i_Hset_r = i_Hset_l*H;
    im_tl = ImageWarping(im1,i_Hset_l);
    im_tr = ImageWarping(im2,i_Hset_r);
    im_temp = (1-w(i,1))*im_tl+w(i,1)*im_tr;
    figure();
    imshow(im_temp);
    imwrite(im_temp,['generated_pics/inter_',num2str(i),'.jpg'],'jpg');
    
end


