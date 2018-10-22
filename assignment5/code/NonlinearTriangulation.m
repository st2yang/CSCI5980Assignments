function X = NonlinearTriangulation(X_in,u1,R1,C1,u2,R2,C2)

% preprocess: trash some points
% idx_s = CheckCheirality(X,C1,R1,C2,R2);
% X = X(idx_s,:);
% u1 = u1(idx_s,:);
% u2 = u2(idx_s,:);

X = X_in;
size_x = size(X,1);

idx1 = create_gaparray(2,size(X,1));
idx2 = create_gaparray(2,size(X,1))+2;

% reshape into b
u1_t = u1';
u1_t = u1_t(:);
u2_t = u2';
u2_t = u2_t(:);
b = zeros(4*size_x,1);
b(idx1,:) = u1_t;
b(idx2,:) = u2_t;

% specify the number of iterations
nIters = 1000;

for i = 1:nIters
    
    % compute jacobian
    df_dX_1 = JacobianX(R1,X,u1);
    df_dX_2 = JacobianX(R2,X,u2);
    
    df_dX = zeros(4*size_x,3*size_x);
    df_dX(idx1,:) = df_dX_1;
    df_dX(idx2,:) = df_dX_2;
    
    % compute f(X)
    t1 = R1*(X-C1')';
    f1 = t1(1:2,:)./t1(3,:);
    f1 = f1(:);
    t2 = R2*(X-C2')';
    f2 = t2(1:2,:)./t2(3,:);
    f2 = f2(:);
    f = zeros(4*size_x,1);
    f(idx1,:) = f1;
    f(idx2,:) = f2;
    
    % terminate loop
    cost_f(i,1) = norm(b-f);
    if i >1
        
        if cost_f(i,1)>cost_f(i-1,1)
           
            break;
            
        end
        
    end
    
    % compute dx
    dx = (df_dX'*df_dX+5*eye(3*size_x))\(df_dX'*(b-f));
    
    X = X+(reshape(dx,[3,size_x]))';
    
end

% figure();
% plot(1:i,cost_f);

end