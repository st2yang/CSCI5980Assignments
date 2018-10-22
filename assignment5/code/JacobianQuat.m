function df_dq = JacobianQuat(R,C,u_p,X)

p = size(u_p,1);

df_dq = zeros(2*p,4);

for j = 0:p-1
    
    u = u_p(j+1,1);
    v = u_p(j+1,2);
    % w = 1;
    
    X_t = X(j+1,:)';
    
    duvw_dR = [(X_t-C)' zeros(1,3) zeros(1,3);...
              zeros(1,3) (X_t-C)' zeros(1,3);...
              zeros(1,3) zeros(1,3) (X_t-C)'];
    
    q = Rotation2Quaternion(R);
    qw = q(1,1);
    qx = q(2,1);
    qy = q(3,1);
    qz = q(4,1);
          
    dR_dq = [0 0 -4*qy -4*qz;...
             -2*qz 2*qy 2*qx -2*qw;...
             2*qy 2*qz 2*qw 2*qx;...
             2*qz 2*qy 2*qx 2*qw;...
             0 -4*qx 0 -4*qz;...
             -2*qx -2*qw 2*qz 2*qy;...
             -2*qy 2*qz -2*qw 2*qx;...
             2*qx 2*qw 2*qz 2*qy;...
             0 -4*qx -4*qy 0];
    
    duvw_q = duvw_dR*dR_dq;
    du_dq = duvw_q(1,:);
    dv_dq = duvw_q(2,:);
    dw_dq = duvw_q(3,:);
    
    
    df_dq(2*j+1:2*j+2,:) = [du_dq-u*dw_dq;...
                            dv_dq-v*dw_dq];
    
end

end