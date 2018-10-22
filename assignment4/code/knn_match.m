function [matches_a,matches_b] = knn_match(Ia,Ib)

Ia1 = single(rgb2gray(Ia));
[fa,da] = vl_sift(Ia1);
Ib1 = single(rgb2gray(Ib));
[fb,db] = vl_sift(Ib1);

% from Ia to Ib
IDX_a = knnsearch(double(db'),double(da'));

matches_a = fa(1:2,:)';
matches_b = fb(1:2,IDX_a)';

end