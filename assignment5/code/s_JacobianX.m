function df_dX = s_JacobianX(R,u_p)

df_dX = zeros(2,3);

du_dX = R(1,:);
dv_dX = R(2,:);
dw_dX = R(3,:);


u = u_p(:,1);
v = u_p(:,2);
% w = 1;

df_dX = [du_dX-u*dw_dX;...
    dv_dX-v*dw_dX];

end