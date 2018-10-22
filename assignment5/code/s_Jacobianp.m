function df_dp = s_Jacobianp(R,C,u_p,X)
% jacobian w.r.t pose for a single camera

df_dq = zeros(2,4);

df_dC = zeros(2,3);

du_dC = -R(1,:);
dv_dC = -R(2,:);
dw_dC = -R(3,:);


u = u_p(:,1);
v = u_p(:,2);
% w = 1;

% df_dC
df_dC = [du_dC-u*dw_dC;...
    dv_dC-v*dw_dC];

% df_dq
X_t = X';

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


df_dq = [du_dq-u*dw_dq;...
    dv_dq-v*dw_dq];

df_dp = [df_dq df_dC];

end