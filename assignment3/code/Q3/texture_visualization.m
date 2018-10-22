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



w = round(u12(1) - u11(1));
h = round((U11(2)-U21(2)) * w / (U12(1)-U11(1)));
d = round((U11(3)-V11(3)) * w / (U12(1)-U11(1)));

H_top  = ComputeHomography([1 1 1; w 1 1; w d 1; 1 d 1], [v21'; v22'; u22'; u21']);
H_bot  = ComputeHomography([1 1 1; w 1 1; w d 1; 1 d 1], [u11'; u12'; v12'; v11']);
H_back = ComputeHomography([1 1 1; w 1 1; w h 1; 1 h 1], [u21'; u22'; u12'; u11']);
H_left = ComputeHomography([1 1 1; d 1 1; d h 1; 1 h 1], [v21'; u21'; u11'; v11']);
H_right= ComputeHomography([1 1 1; d 1 1; d h 1; 1 h 1], [u22'; v22'; v12'; u12']);

top  = ImWarpWindow(im,H_top,[d w]);
bot  = ImWarpWindow(im, H_bot, [d w]);
back = ImWarpWindow(im, H_back,[h w]);
left = ImWarpWindow(im, H_left,[h d]);
right= ImWarpWindow(im, H_right,[h d]);



% 3D visualization
cube = uint8(255 * ones(d+h+d, d+w+d, 3));
cube(1:d, d+1:d+w, :) = top;
cube(d+1:d+h, 1:d, :) = left;
cube(d+1:d+h, d+1:d+w, :) = back;
cube(d+1:d+h, d+w+1:end, :) = right;
cube(d+h+1:end, d+1:d+w, :) = bot;

figure();
imshow(cube)
drawnow

%% 3D View
figure();
clf;
surface([0 w; 0 w], [d d; 0 0], [0 0; 0 0], ...
    'FaceColor', 'texturemap', 'CData', bot );
surface([0 w; 0 w], [0 0; d d], [h h; h h], ...
    'FaceColor', 'texturemap', 'CData', top );
surface([0 0; 0 0], [0 d; 0 d], [h h; 0 0], ...
    'FaceColor', 'texturemap', 'CData', left );
surface([w w; w w], [d 0; d 0], [h h; 0 0], ...
    'FaceColor', 'texturemap', 'CData', right );
surface([0 w; 0 w], [d d; d d], [h h; 0 0], ...
    'FaceColor', 'texturemap', 'CData', back );
axis equal
for i = -35:1:35
    view(i, 15)
    drawnow
    pause(0.03)
end
