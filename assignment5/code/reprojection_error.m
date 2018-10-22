function err = reprojection_error(P,X,u)

id_x = (X(:,1) ~= -1) & (X(:,2) ~= -1) & (X(:,3) ~= -1);
id_u = (u(:,1) ~= -1) & (u(:,2) ~= -1);

id = id_x & id_u;

X = X(id,:);
u = u(id,:);

u1 = [X ones(size(X,1),1)]*P';
u1 = u1(:,1:2)./u1(:,3);

err = norm(u-u1);

end