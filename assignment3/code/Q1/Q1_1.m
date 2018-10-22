% Single Image Calibration

clear; close all; clc;

m11 = [2797;2883;1];
m12 = [2900;2088;1];
m13 = [1623;1781;1];
m14 = [1204;2416;1];

m21 = m11;
m22 = m14;
m23 = m12;
m24 = m13;

z11 = [1484; 595; 1];
z12 = [1531; 1521; 1];
z21 = [2950; 819; 1];
z22 = [2736; 1780; 1];

l11 = GetLineFromTwoPoints(m11,m12);
l12 = GetLineFromTwoPoints(m13,m14);

l21 = GetLineFromTwoPoints(m21,m22);
l22 = GetLineFromTwoPoints(m23,m24);

l31 = GetLineFromTwoPoints(z11,z12);
l32 = GetLineFromTwoPoints(z21,z22);

x = GetPointFromTwoLines(l11,l12);
y = GetPointFromTwoLines(l21,l22);
z = GetPointFromTwoLines(l31,l32);

A = [x(1)*y(1)+x(2)*y(2) x(1)+y(1) x(2)+y(2) 1;
     z(1)*y(1)+z(2)*y(2) z(1)+y(1) z(2)+y(2) 1;
     x(1)*z(1)+x(2)*z(2) x(1)+z(1) x(2)+z(2) 1];
[u d v] = svd(A);
x1 = v(:,end);
px = -x1(2)/x1(1);
py = -x1(3)/x1(1);
f = sqrt(x1(4)/x1(1)-px^2-py^2);

K = [f 0 px;
     0 f py;
     0 0 1];
 
 figure(1);
clf;
im = imread('pics/Q1_1.jpg');
hold on
d0 = m11(1);
d1 = x(1);
y1 = -(l11(1)*d0+l11(3))/l11(2);
y2 = -(l11(1)*d1+l11(3))/l11(2);
plot([d0 d1], [y1 y2], 'r-');

hold on
d0 = m14(1);
d1 = x(1);
y1 = -(l12(1)*d0+l12(3))/l12(2);
y2 = -(l12(1)*d1+l12(3))/l12(2);
plot([d0 d1], [y1 y2], 'r-');

hold on
d0 = m11(1);
d1 = y(1);
y1 = -(l21(1)*d0+l21(3))/l21(2);
y2 = -(l21(1)*d1+l21(3))/l21(2);
plot([d0 d1], [y1 y2], 'g-');

hold on
d0 = m12(1);
d1 = y(1);
y1 = -(l22(1)*d0+l22(3))/l22(2);
y2 = -(l22(1)*d1+l22(3))/l22(2);
plot([d0 d1], [y1 y2], 'g-');
hold on

hold on
d0 = z11(1);
d1 = z(1);
y1 = -(l31(1)*d0+l31(3))/l31(2);
y2 = -(l31(1)*d1+l31(3))/l31(2);
plot([d0 d1], [y1 y2], 'b-');

hold on
d0 = z21(1);
d1 = z(1);
y1 = -(l32(1)*d0+l32(3))/l32(2);
y2 = -(l32(1)*d1+l32(3))/l32(2);
plot([d0 d1], [y1 y2], 'b-');
hold on

imshow(im);
hold on
    d0 = m11(1);
d1 = x(1);
y1 = -(l11(1)*d0+l11(3))/l11(2);
y2 = -(l11(1)*d1+l11(3))/l11(2);
plot([d0 d1], [y1 y2], 'r-', 'LineWidth', 2);

hold on
d0 = m14(1);
d1 = x(1);
y1 = -(l12(1)*d0+l12(3))/l12(2);
y2 = -(l12(1)*d1+l12(3))/l12(2);
plot([d0 d1], [y1 y2], 'r-', 'LineWidth', 2);

hold on
d0 = m11(1);
d1 = y(1);
y1 = -(l21(1)*d0+l21(3))/l21(2);
y2 = -(l21(1)*d1+l21(3))/l21(2);
plot([d0 d1], [y1 y2], 'g-', 'LineWidth', 2);

hold on
d0 = m12(1);
d1 = y(1);
y1 = -(l22(1)*d0+l22(3))/l22(2);
y2 = -(l22(1)*d1+l22(3))/l22(2);
plot([d0 d1], [y1 y2], 'g-', 'LineWidth', 2);
hold on

hold on
d0 = z11(1);
d1 = z(1);
y1 = -(l31(1)*d0+l31(3))/l31(2);
y2 = -(l31(1)*d1+l31(3))/l31(2);
plot([d0 d1], [y1 y2], 'b-', 'LineWidth', 2);

hold on
d0 = z21(1);
d1 = z(1);
y1 = -(l32(1)*d0+l32(3))/l32(2);
y2 = -(l32(1)*d1+l32(3))/l32(2);
plot([d0 d1], [y1 y2], 'b-', 'LineWidth', 2);
hold on

