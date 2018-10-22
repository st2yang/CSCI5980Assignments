function x = GetPointFromTwoLines(l1,l2)

% l1 = [-398;-752;1404124];
% l2 = [310;-924;303790];
x = Vec2Skew(l1)*l2;
x = x/x(3);

% im = imread('undistorted.png');
% figure(1)
% clf
% imshow(im);
% hold on
% plot(x(1),x(2), 'rx');