function df_dC = JacobianC(R,u_p)
% jacobian for a single camera who see all points
% u_p is for all points, in pixel coordinate
% u_p size p by 2

p = size(u_p,1);

df_dC = zeros(2*p,3);

du_dC = -R(1,:);
dv_dC = -R(2,:);
dw_dC = -R(3,:);

for j = 0:p-1
    
    u = u_p(j+1,1);
    v = u_p(j+1,2);
    % w = 1;
    
    df_dC(2*j+1:2*j+2,:) = [du_dC-u*dw_dC;...
                            dv_dC-v*dw_dC];
                        
end

end