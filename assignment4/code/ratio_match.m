function [matches_a,matches_b] = ratio_match(Ia,Ib,ratio)

Ia1 = single(rgb2gray(Ia));
[fa,da] = vl_sift(Ia1,'PeakThresh',1);
Ib1 = single(rgb2gray(Ib));
[fb,db] = vl_sift(Ib1,'PeakThresh',1);

% from Ia to Ib
IDX_init = knnsearch(double(db'),double(da'),'K',2);

IDX_can = IDX_init(:,1);

temp = ratio-vecnorm(da-db(:,IDX_init(:,1)))./vecnorm(da-db(:,IDX_init(:,2)));

ID_s = find(temp' > 0);

fa_s = fa(:,ID_s);

IDX_select = IDX_can(ID_s,:);

fb_s = fb(:,IDX_select');

matches_a = fa_s(1:2,:)';
matches_b = fb_s(1:2,:)';

end