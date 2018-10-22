function df_dX = JacobianX(R,X,u_p)
% jacobian for all points on a single camera
% u_p is for all points, in pixel coordinate
% u_p size p by 2

p = size(X,1);

df_dX = zeros(2*p,3*p);

du_dX = R(1,:);
dv_dX = R(2,:);
dw_dX = R(3,:);

for j = 0:p-1
    
    u = u_p(j+1,1);
    v = u_p(j+1,2);
    % w = 1;
    
    df_dX(2*j+1:2*j+2,3*j+1:3*j+3) = [du_dX-u*dw_dX;...
                                      dv_dX-v*dw_dX];
    
end

end