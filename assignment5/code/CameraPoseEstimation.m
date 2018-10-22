function [R,C,X,idx_ref] = CameraPoseEstimation(u_input,v_input,Ia,Ib)

global K;

[u,v,idx_ref] = reference_filter(u_input,v_input);

% fundamental matrix with ransac
[F,~,~,inliers] = ComputeFundamentalMatrix_RANSAC(u',v',0.7,10000,size(u,1));
u_in = u(inliers,:);
v_in = v(inliers,:);
idx_ref = idx_ref(inliers,:);

% camera pose
E = K'*F*K;

[U,d,V] = svd(E);
d(1,1) = 1;
d(2,2) = 1;
d(3,3) = 0;
E = U*d*V';

t0 = U(:,3);

W1 = [0 -1 0;...
      1 0 0;...
      0 0 1];

t1 = t0;
R1 = U * W1 * V';
if det(R1) < 0
    R1 = -R1;
end

t2 = -t0;
R2 = R1;

W2 = [0 1 0;...
      -1 0 0;...
      0 0 1];

t3 = t0;
R3 = U * W2 * V';
if det(R3) < 0
    R3 = -R3;
end

t4 = -t0;
R4 = R3;

R0 = eye(3);
t0 = zeros(3,1);
% cheirality
Rs = zeros(3,3,4);
Rs(:,:,1) = R1;
Rs(:,:,2) = R2;
Rs(:,:,3) = R3;
Rs(:,:,4) = R4;
ts = zeros(3,4);
ts(:,1) = t1;
ts(:,2) = t2;
ts(:,3) = t3;
ts(:,4) = t4;
Cs = zeros(3,4);
Cs(:,1) = -R1'*t1;
Cs(:,2) = -R2'*t2;
Cs(:,3) = -R3'*t3;
Cs(:,4) = -R4'*t4;

maxValid = 0;
P1 = K*[R0 t0];
for i = 1:4
    P2 = K*[Rs(:,:,i) ts(:,i)];
    
    for j = 1 : size(u_in,1)
        Y(j,:) = LinearTriangulation(P1,u_in(j,:),P2,v_in(j,:));
    end
        
    if size(CheckCheirality(Y,t0,R0,Cs(:,i),Rs(:,:,i)),1) > maxValid
    
        R_s = Rs(:,:,i);
        t_s = ts(:,i);
        C_s = Cs(:,i);
        Y_s = Y;
        idx_s = CheckCheirality(Y_s,t0,R0,Cs(:,i),Rs(:,:,i));
        maxValid = size(idx_s,1);
%         idx = i;
        
    end
    
%     z_avg = mean(abs(Y(:,3)));
%     
%     z_idx = find(abs(Y(:,3)) > 3*z_avg);
%     
%     Y(z_idx,:) = [];
%     
%     scale = 0.2*mean(abs(Y(:,3)));
%     
%     figure();
%     plot3(Y(:,1), Y(:,2), Y(:,3), 'b.');
%     hold on
%     DisplayCamera(t0,R0,scale);
%     hold on
%     DisplayCamera(Cs(:,i),Rs(:,:,i),scale);
%     view(0,0);
    
end

% maxValid


% Y_s1 = NonlinearTriangulation(Y_s,u_in,eye(3),zeros(3,1),v_in,R_s,C_s);

% return
R = R_s;
C = C_s;
X = Y_s;

% plot
% figure();
% plot3(Y_s(:,1), Y_s(:,2), Y_s(:,3), 'b.');
% hold on;
% DisplayCamera(zeros(3,1), eye(3), 0.05*max(max(abs(Y_s))));
% hold on;
% DisplayCamera(C_s, R_s, 0.05*max(max(abs(Y_s))));
% hold on;
% view(0,0);

% reproject_visualization_allidx(Y_s,Ia,R_s,C_s,pixel2normalized(v_in));

end