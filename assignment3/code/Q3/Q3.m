% Tour into Your Picture

clear; close all; clc;

im = imread('pics/Q3_rect.jpg');
% imshow(im);

f = 3351.6;
px = size(im,2)/2;
py = size(im,1)/2;
K = [f 0 px; 0 f py; 0 0 1];



% vanish point in Z direction

m11 = [2462;2675;1];
m12 = [2315;2251;1];
m21 = [1595;2667;1];
m22 = [1771;2249;1];
m31 = [2643;739;1];
m32 = [2459;992;1]; 
m41 = [1427;743;1];
m42 = [1631;1000;1];

l1 = skewsymm(m11)*m12;
l2 = skewsymm(m21)*m22;
l3 = skewsymm(m31)*m32;
l4 = skewsymm(m41)*m42;

A = [l1';l2';l3';l4'];
[~, ~, v] = svd(A);
p = v(:,end);
p = p/p(3,1);

% verify result from Ax=0
% l1_t = GetLineFromTwoPoints(m11,m12);
% l2_t = GetLineFromTwoPoints(m21,m22);
% p_t = GetPointFromTwoLines(l1_t,l2_t);



% 3D box generation

u11 = [1487;2129;1];
u12 = [2605;2129;1];
u21 = [1487;1086;1];
u22 = [2605;1086;1];

v11 = [1075;2540;1];
v12 = [2983;2540;1];
v21 = [1075;785;1];
v22 = [2983;785;1];

% self-defined depth of u_ii plane
d = 1;
U11 = d*inv(K)*u11;
U12 = d*inv(K)*u12;
U21 = d*inv(K)*u21;
U22 = d*inv(K)*u22;

% find V_ii by lambda1
a = inv(K)*v11;
b = inv(K)*p;
c = d*inv(K)*u11;
sols = [a(1,1) b(1,1);a(2,1) b(2,1);a(3,1) b(3,1)]\c;
V11 = sols(1,1)*inv(K)*v11;

a = inv(K)*v12;
b = inv(K)*p;
c = d*inv(K)*u12;
sols = [a(1,1) b(1,1);a(2,1) b(2,1);a(3,1) b(3,1)]\c;
V12 = sols(1,1)*inv(K)*v12;

a = inv(K)*v21;
b = inv(K)*p;
c = d*inv(K)*u21;
sols = [a(1,1) b(1,1);a(2,1) b(2,1);a(3,1) b(3,1)]\c;
V21 = sols(1,1)*inv(K)*v21;

a = inv(K)*v22;
b = inv(K)*p;
c = d*inv(K)*u22;
sols = [a(1,1) b(1,1);a(2,1) b(2,1);a(3,1) b(3,1)]\c;
V22 = sols(1,1)*inv(K)*v22;



% compute homographies of five planes
% al1,al2 is the direction vector 
% origing from the left corner of each plane
% al3 is the left coner origin(translation vector) 

% plane1:forward 
% u11,u12,u21,u22
al1_p1 = U12-U11;
al2_p1 = U21-U11;
al3_p1 = U11;
als_p1 = [al1_p1 al2_p1 al3_p1];
s_H_plane1 = K*als_p1;

% plane2: upward
% u21 u22 v21 v22
al1_p2 = U22-U21;
al2_p2 = V21-U21;
al3_p2 = U21;
als_p2 = [al1_p2 al2_p2 al3_p2];
s_H_plane2 = K*als_p2;

% plane3:downward 
% v11,v12,u11,u12
al1_p3 = V12-V11;
al2_p3 = U11-V11;
al3_p3 = V11;
als_p3 = [al1_p3 al2_p3 al3_p3];
s_H_plane3 = K*als_p3;

% plane4:left 
% v11,u11,v21,u21
al1_p4 = U11-V11;
al2_p4 = V21-V11;
al3_p4 = V11;
als_p4 = [al1_p4 al2_p4 al3_p4];
s_H_plane4 = K*als_p4;

% plane5:right 
% u12,v12,u22,v22
al1_p5 = V12-U12;
al2_p5 = U22-U12;
al3_p5 = U12;
als_p5 = [al1_p5 al2_p5 al3_p5];
s_H_plane5 = K*als_p5;

s_H_plane = zeros(3,3,5);
s_H_plane(:,:,1) = s_H_plane1;
s_H_plane(:,:,2) = s_H_plane2;
s_H_plane(:,:,3) = s_H_plane3;
s_H_plane(:,:,4) = s_H_plane4;
s_H_plane(:,:,5) = s_H_plane5;

als_p(:,:,1) = als_p1;
als_p(:,:,2) = als_p2;
als_p(:,:,3) = als_p3;
als_p(:,:,4) = als_p4;
als_p(:,:,5) = als_p5;



% cut off the images into five parts

dim_w = round(u12(1) - u11(1));
dim_h = round((U11(2)-U21(2)) * dim_w / (U12(1)-U11(1)));
dim_d = round((U11(3)-V11(3)) * dim_w / (U12(1)-U11(1)));

H_top  = ComputeHomography([1 1 1; dim_w 1 1; dim_w dim_d 1; 1 dim_d 1], [v21'; v22'; u22'; u21']);
H_bot  = ComputeHomography([1 1 1; dim_w 1 1; dim_w dim_d 1; 1 dim_d 1], [u11'; u12'; v12'; v11']);
H_back = ComputeHomography([1 1 1; dim_w 1 1; dim_w dim_h 1; 1 dim_h 1], [u21'; u22'; u12'; u11']);
H_left = ComputeHomography([1 1 1; dim_d 1 1; dim_d dim_h 1; 1 dim_h 1], [v21'; u21'; u11'; v11']);
H_right= ComputeHomography([1 1 1; dim_d 1 1; dim_d dim_h 1; 1 dim_h 1], [u22'; v22'; v12'; u12']);

top_t  = ImWarpWindow(im,H_top,[dim_d dim_w]);
bot_t  = ImWarpWindow(im, H_bot, [dim_d dim_w]);
back_t = ImWarpWindow(im, H_back,[dim_h dim_w]);
left_t = ImWarpWindow(im, H_left,[dim_h dim_d]);
right_t = ImWarpWindow(im, H_right,[dim_h dim_d]);

top  = ImageWarpingGivenTargetImage(top_t,inv(H_top),im);
bot  = ImageWarpingGivenTargetImage(bot_t, inv(H_bot),im);
back = ImageWarpingGivenTargetImage(back_t, inv(H_back),im);
left = ImageWarpingGivenTargetImage(left_t, inv(H_left),im);
right= ImageWarpingGivenTargetImage(right_t, inv(H_right),im);

plane(:,:,:,1) = back;
plane(:,:,:,2) = top;
plane(:,:,:,3) = bot;
plane(:,:,:,4) = left;
plane(:,:,:,5) = right;




% camera motion to create virtual tour

% target image of pure rotation
% about Y axis of the camera with 20 degree
theta = 20/180*pi;
R = [cos(theta) 0 sin(theta);
     0 1 0;
     -sin(theta) 0 cos(theta)];
t = [0;0;0];

im_stitch1 = zeros(size(im));
for j = 1:5
    t_H_plane = K*[R*als_p(:,1,j) R*als_p(:,2,j) R*als_p(:,3,j)+t];
    
    t_H_s_p = t_H_plane*inv(s_H_plane(:,:,j));
    
    im_warped = ImageWarping(plane(:,:,:,j),t_H_s_p);
    im_stitch1 = im_stitch1 + double(im_warped);
end

im_stitch1 = uint8(im_stitch1);
% imshow(im_stitch1);
imwrite(im_stitch1,'pics/stitch1.jpg')


% a target image of pure translation
% along Z axis of the camera with 0.2d
R = eye(3);
t = [0;0;-0.2*d];

im_stitch2 = zeros(size(im));
for j = 1:5
    t_H_plane = K*[R*als_p(:,1,j) R*als_p(:,2,j) R*als_p(:,3,j)+t];
    
    t_H_s_p = t_H_plane*inv(s_H_plane(:,:,j));
    
    im_warped = ImageWarping(plane(:,:,:,j),t_H_s_p);
    im_stitch2 = im_stitch2 + double(im_warped);
end

im_stitch2 = uint8(im_stitch2);
% imshow(im_stitch2);
imwrite(im_stitch2,'pics/stitch2.jpg')




% create a video
% first turn right while walking forward
% then turn left while walking
R1 = eye(3);
C1 = [0;0;0];

theta = -10/180*pi;
R2 = [cos(theta) 0 sin(theta);
     0 1 0;
     -sin(theta) 0 cos(theta)];
C2 = [0;0;-0.4*d];

% specify number of images for video
NV = 30;

Rset = cell(1,NV+1);
Cset = zeros(3,NV+1);
[Rset_1, Cset_1] = InterpolateCoordinate(R1, C1, R2, C2, NV/2);
R3 = eye(3);
C3 = [0;0;-0.8*d];
[Rset_2, Cset_2] = InterpolateCoordinate(R2, C2, R3, C3, NV/2);

for k = 1:NV+1
    if k <= NV/2
        Rset{k} = Rset_1{k};
        Cset(:,k) = Cset_1(:,k);
    else
        Rset{k} = Rset_2{k - NV/2};
        Cset(:,k) = Cset_2(:,k - NV/2);
    end
end

im_total = cell(NV+1,1);
for i = 1:NV+1
    im_stitch = zeros(size(im));
    R = cell2mat(Rset(i));
    t = Cset(:,i);
    
    for j = 1:5
        t_H_plane = K*[R*als_p(:,1,j) R*als_p(:,2,j) R*als_p(:,3,j)+t];
        
        t_H_s_p = t_H_plane*inv(s_H_plane(:,:,j));
        
        im_warped = ImageWarping(plane(:,:,:,j),t_H_s_p);
        im_stitch = im_stitch + double(im_warped);
    end
    
    im_stitch = uint8(im_stitch);
    im_total{i} = im_stitch;
    imshow(im_stitch);
%     imwrite(im_stitch,['pics/video/Image0',num2str(i),'.jpg'],'jpg');
end



% write imgaes into a gif file
filename = 'video.gif'; % Specify the output file name
for idx = 1:size(im_total,1)
    [A,map] = rgb2ind(im_total{idx},256);
    if idx == 1
        imwrite(A,map,filename,'gif','LoopCount',Inf,'DelayTime',1);
    else
        imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',1);
    end
end
