% Multiple Image Calibration

% clear; close all; clc;

np = 4;
X= 0.03*[0,0;
    9,0;
    9,7;
    0,7];
X = [X ones(np,1)];

load('Q2_cornerspixel.mat');
h1 = ComputeHomography(u1,X);
h2 = ComputeHomography(u2,X);
h3 = ComputeHomography(u3,X);
h4 = ComputeHomography(u4,X);
h5 = ComputeHomography(u5,X);
h6 = ComputeHomography(u6,X);


H = [h1;h2;h3;h4;h5;h6];
A = [];
for i = 1:6
    
    h_s = H((i-1)*3+1:3*i,:);
    A = [A;
        h_s(1,1)*h_s(1,2)+h_s(2,1)*h_s(2,2),h_s(1,1)*h_s(3,2)+h_s(1,2)*h_s(3,1),h_s(2,1)*h_s(3,2)+h_s(2,2)*h_s(3,1),h_s(3,2)*h_s(3,1);
        h_s(1,1)^2-h_s(1,2)^2+h_s(2,1)^2-h_s(2,2)^2,2*(h_s(1,1)*h_s(3,1)-h_s(1,2)*h_s(3,2)),2*(h_s(2,1)*h_s(3,1)-h_s(2,2)*h_s(3,2)),h_s(3,1)^2-h_s(3,2)^2];
    
end

[u, d, v] = svd(A);
b = v(:,end);

p_x = -b(2,1)/b(1,1)
p_y = -b(3,1)/b(1,1)
f = sqrt(b(4,1)/b(1,1)-(p_x^2+p_y^2))
