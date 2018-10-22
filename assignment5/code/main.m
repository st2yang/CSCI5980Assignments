clear; close all; clc;

% specify the path of vl_feat
run('../vlfeat-0.9.21/toolbox/vl_setup.m');

% read images
N = 6;
I = cell(N,1);
for i = 1:N
      I{i} = imread(['pics/I',num2str(i),'.jpg']);
end

global K;
K = [700 0 960;
     0 700 540;
     0 0 1];

%%
[Mx,My] = GetMatches(I);

% plot
% idx1 = (Mx(:,1) ~= -1) & (Mx(:,2) ~= -1);
% matching_visualization(I{1},I{2},normalized2pixel([Mx(idx1,1) My(idx1,1)]),normalized2pixel([Mx(idx1,2) My(idx1,2)]));

X = -ones(size(Mx,1),3);

[R2,C2,X_init,idx_ref] = CameraPoseEstimation(normalized2pixel([Mx(:,1) My(:,1)]),normalized2pixel([Mx(:,2) My(:,2)]),I{1},I{2});
X(idx_ref,:) = X_init;


r = [1;2];
Ps{1} = RC2projection(eye(3),zeros(3,1));
Ps{2} = RC2projection(R2,C2);

for k = 3:N
   
    i = k;
    
    [R_i,C_i] = RansacPnP([Mx(:,i) My(:,i)],X);
    [R_i,C_i] = NonlinearPnP(R_i,C_i,[Mx(:,i) My(:,i)],X);
    Ps{i} = RC2projection(R_i,C_i);
    
    for f = 1:length(r)
        
        id_un = FindUnreconstructedPoints(X,r(f),i,Mx,My);
        
        u = [Mx(id_un,i) My(id_un,i)];
        v = [Mx(id_un,f) My(id_un,f)];
        Xnew = zeros(size(u,1),3);
        
        for j = 1:size(u,1)
            
            Xnew(j,:) = LinearTriangulation(Ps{i},u(j,:),Ps{f},v(j,:));
            
        end
        
        [Rt1,Ct1] = projection2RC(Ps{i});
        [Rt2,Ct2] = projection2RC(Ps{f});
        Xnew = NonlinearTriangulation(Xnew,u,Rt1,Ct1,v,Rt2,Ct2);        
        
        X(id_un,:) = Xnew;
        
    end
    
    r = [r;i];
    
    X = convertX(X);
    [Ps1,X] = BundleAdjustment(Ps,X,r,Mx,My);
    X = X(1:3,:)';
    
end

% figure();
% plot3(X(:,1), X(:,2), X(:,3), 'b.');
% view(0,0);
% for i =1:N
%     hold on;
%     [Rt,Ct] = projection2RC(Ps{i});
%     DisplayCamera(Ct, Rt, 0.025*max(max(abs(X))));
% end
% 
for i = 1:N
    [Rt,Ct] = projection2RC(Ps{i});
    reproject_visualization_allidx(X,I{i},Rt,Ct,[Mx(:,i) My(:,i)]);
end

