function im_warped = ImageWarpingGivenTargetImage(im, H, im_warped)

% Image warping inspired by Ethan Meyers
% (http://emeyers.scripts.mit.edu/emeyers/)

H = inv(H);

[m_w n_w d] = size(im_warped);

[x_coord y_coord] = meshgrid(1:n_w, 1:m_w);
x = H(1,1)*x_coord+H(1,2)*y_coord+H(1,3);
y = H(2,1)*x_coord+H(2,2)*y_coord+H(2,3);
z = H(3,1)*x_coord+H(3,2)*y_coord+H(3,3);

x_coord_new = floor(x./z);
y_coord_new = floor(y./z);

[m n d] = size(im);

idx1 = find(x_coord_new < 1);
idx2 = find(x_coord_new > n);
idx3 = find(y_coord_new < 1);
idx4 = find(y_coord_new > m);

x_coord_new(idx1) = 1; 
x_coord_new(idx2) = n; 
y_coord_new(idx3) = 1; 
y_coord_new(idx4) = m; 

new_index = sub2ind([m,n], y_coord_new(:), x_coord_new(:));
index = sub2ind([m_w,n_w], y_coord(:), x_coord(:));

r = reshape(im(:,:,1), 1, n*m);
g = reshape(im(:,:,2), 1, n*m);
b = reshape(im(:,:,3), 1, n*m);

idx = unique([idx1;idx2;idx3;idx4]);

index(idx) = [];
new_index(idx) = [];

r_new = zeros(m_w,n_w);
g_new = zeros(m_w,n_w);
b_new = zeros(m_w,n_w);

r_new(index) = r(new_index);
g_new(index) = g(new_index);
b_new(index) = b(new_index);

% im_warped = zeros(m,n,3);
im_warped(:,:,1) = r_new;
im_warped(:,:,2) = g_new;
im_warped(:,:,3) = b_new;

im_warped = uint8(im_warped);  % convert back to uint8