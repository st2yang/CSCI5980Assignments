function [R,C] = NonlinearPnP(R_in,C_in,u_in,X_in)

bool_u = u_in(:,1) ~= -1;
bool_X = X_in(:,1) ~= -1;

bool = bool_u & bool_X;

u = u_in(bool,:);
X = X_in(bool,:);

R = R_in;
C = C_in;

% add noise for testing optzn
% R = aa2rot(rand(3,1),0.02*rand(1))*R_in;
% C = C_in+0.02*rand(3,1);

size_x = size(X,1);

% reshape into b
u_t = u';
b = u_t(:);

% specify the number of iterations
nIters = 1000;

for i = 1:nIters
    
    % compute jacobian
    df_dC = JacobianC(R,u);
    df_dq = JacobianQuat(R,C,u,X);
    df_dp = [df_dq,df_dC];
    
    % compute f(p)
    t = R*(X-C')';
    f = t(1:2,:)./t(3,:);
    f = f(:);
    
    % terminate the loop
    cost_f(i,1) = norm(b-f);
    if i >1
        
        if cost_f(i,1)>cost_f(i-1,1)
            
            break;
            
        end
        
    end
    
    % compute dp
    dp = 0.1*((df_dp'*df_dp+10*eye(7))\(df_dp'*(b-f)));
    
    q = Rotation2Quaternion(R)+dp(1:4,1);
    q = q/norm(q);
    R = Quaternion2Rotation(q);
    C = C+dp(5:7,:);
    
end

% figure();
% plot(1:i,cost_f);

end