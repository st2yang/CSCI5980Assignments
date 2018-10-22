function [matches_a,matches_b,idx_a,idx_b] = ratio_match(fa,da,fb,db,ratio)

% from Ia to Ib
IDX_init = knnsearch(double(db'),double(da'),'K',2);

IDX_can = IDX_init(:,1);

temp = ratio-vecnorm(da-db(:,IDX_init(:,1)))./vecnorm(da-db(:,IDX_init(:,2)));

idx_a = find(temp' > 0);

fa_s = fa(:,idx_a);

idx_b = IDX_can(idx_a,:);

fb_s = fb(:,idx_b');

matches_a = fa_s(1:2,:)';
matches_b = fb_s(1:2,:)';

end