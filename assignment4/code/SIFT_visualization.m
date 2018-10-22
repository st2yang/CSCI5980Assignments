function SIFT_visualization(I,N)

figure();
imshow(I);

I = single(rgb2gray(I));

[f, ~] = vl_sift(I);

perm = randperm(size(f,2));
sel = perm(1:N);
h1 = vl_plotframe(f(:,sel));
h2 = vl_plotframe(f(:,sel));
set(h1,'color','k','linewidth',3);
set(h2,'color','y','linewidth',2);

end