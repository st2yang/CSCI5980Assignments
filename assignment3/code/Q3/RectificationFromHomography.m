im = imread('pics/SmithF2.jpg');

f = 3351.6;
K = [f 0 size(im,2)/2;
     0 f size(im,1)/2;
     0 0 1];


m11 = [2575;2452;1];m12 = [2450;2098;1];m13 = [1632;2105;1];m14 = [1490;2460;1];

u = [m11(1:2)';m12(1:2)';m13(1:2)'; m14(1:2)'];
X = [0 0;1 0;1 1;0 1];
X = [X ones(4,1)]; % homogeneous coordinate

H = ComputeHomography(u, X);

denom = norm(inv(K)*H(:,1));
r1 = inv(K)*H(:,1)/denom;
r2 = inv(K)*H(:,2)/denom;
t = inv(K)*H(:,3)/denom;

r3 = Vec2Skew(r1)*r2;

R = [r1 r2 r3];

r2_n = [0 0 -1];
r1_n = (R(1,:) - (R(1,:)*r2_n')*r2_n);
r3_n = Vec2Skew(r1_n)*r2_n';

R_n = [r1_n; r2_n; r3_n'];

H_new = K * R_n * inv(R) * inv(K);

im_warped = ImageWarping(im, H_new);

figure(1)
clf;
imshow(im_warped);

imwrite(im_warped,'pics/Q3_rect.jpg');
