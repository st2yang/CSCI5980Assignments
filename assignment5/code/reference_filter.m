function [u,v,idx_ref] = reference_filter(u_ref,v)
% filter out the points in ref seen by v
% return 2D points and idx in ref

idx_ref = find(v(:,1) ~= -1);
u = u_ref(idx_ref,:);
v = v(idx_ref,:);

end