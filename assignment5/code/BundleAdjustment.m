function [P, X, normHist, gradnormHist] = BundleAdjustment(P,X,measuredPose,Mx,My)

NumOfPoses = length(measuredPose);
FeatTriangulated = find(X(4,:)~=0);
NumOfFeatures = length(FeatTriangulated);

regulator = 1;
norm_iter = 100;
grad_norm = 100;
normHist = [];
gradnormHist = [];
maxIter = 100;
iter = 1;


PoseAndFeat = sum(sum(Mx(FeatTriangulated,:)~=-1));
while iter < maxIter && norm_iter > 1e-1 && grad_norm > 1e-5
    
Jpose = zeros(2*nnz(PoseAndFeat), 6*NumOfPoses);
Jfeat = zeros(2*nnz(PoseAndFeat), 3*NumOfFeatures);
residual = zeros(2*nnz(PoseAndFeat), 1);
meascount = 0;
last_meas_count = 0;

featcount = 0;
last_feat_count = 0;

A22_inv = zeros(3*NumOfFeatures);

featureAvailableList = find(X(4,:));
featureAvailableList = featureAvailableList-1;

for featk = featureAvailableList
      
   poses_see_featk = find(Mx(featk+1, measuredPose)~=-1);
   
   
   for l = 0:length(poses_see_featk)-1
       
      Cr_p_f = X(1:3 ,featk+1);      
      Cl_z_f = [Mx(featk+1,measuredPose(poses_see_featk(l+1)));My(featk+1,measuredPose(poses_see_featk(l+1)))];                  
      
      
      Cl_T_W = P{measuredPose(poses_see_featk(l+1))};
      Cr_T_W = P{X(4, featk+1)};      
      Cl_T_Cr = Cl_T_W*[InversePose(Cr_T_W);zeros(1,3) 1];            
      Cl_p_f = Cl_T_Cr*[Cr_p_f;1];
       
      [Jpose(2*meascount+1:2*meascount+2, 6*(poses_see_featk(l+1)-1)+1:6*(poses_see_featk(l+1)-1)+6),...
          residual(2*meascount+1:2*meascount+2)] = ...
           dprojection_dp_dtt2(Cr_p_f, Cl_T_Cr(:,1:3), Cl_T_Cr(:,4), Cl_z_f);       
       
      Jfeat_s = 1/Cl_p_f(3)*[1 0 -Cl_p_f(1)/Cl_p_f(3);0 1 -Cl_p_f(2)/Cl_p_f(3)] * Cl_T_Cr(:,1:3);
      Jfeat(2*meascount+1:2*meascount+2, 3*featcount+1:3*featcount+3) = Jfeat_s;              
      
      meascount = meascount + 1;
   end   
   
   Jfeatk = Jfeat(last_meas_count+1:2*meascount, 3*featcount+1:3*featcount+3);
   A22_inv(3*featcount+1:3*featcount+3, 3*featcount+1:3*featcount+3) = (Jfeatk'*Jfeatk + regulator*eye(3)) \ eye(3);
      
   featcount = featcount + 1;
   last_meas_count = meascount;
end

norm_iter = norm(residual);
normHist = [normHist norm_iter];
if iter > 20
    norm_iter = 1e2*abs(normHist(end-1) - normHist(end));
end

Jpose_sp = sparse(Jpose);
Jfeat_sp = sparse(Jfeat);
A11 = Jpose_sp'*Jpose_sp;
A12 = Jpose_sp'*Jfeat_sp;
A22_inv_sp = sparse(A22_inv);
res_ = [Jpose_sp'*residual;Jfeat_sp'*residual];

% solve:
p_tilde = (A11 +regulator*speye(size(A11))- A12*A22_inv_sp*A12') \ (res_(1:6*NumOfPoses) - A12*A22_inv_sp*res_(1+6*NumOfPoses:end));

for l = 1:NumOfPoses-1
    dq = [0.5*p_tilde(6*l+4:6*l+6);1];
    dq = dq / norm(dq);
    P{measuredPose(l+1)}(:,1:3) = quat2rot( quat_mul(dq, rot2quat(P{measuredPose(l+1)}(:,1:3))) );       
    P{measuredPose(l+1)}(:,4) = P{measuredPose(l+1)}(:,4) + p_tilde(6*l+1:6*l+3);
end

grad_norm = norm(p_tilde)^2;
 
bf_p = res_(1+6*NumOfPoses:end) - A12'*p_tilde;
f_tilde = A22_inv_sp * bf_p;
X(1:3, featureAvailableList+1) = X(1:3, featureAvailableList+1) + reshape(f_tilde, [3, NumOfFeatures]);

grad_norm = norm(f_tilde)^2 + norm(p_tilde)^2;
gradnormHist = [gradnormHist sqrt(grad_norm)];




    fprintf('Iteration :%d, residual error: %f, norm of dx: %f \n', iter, norm_iter, grad_norm);
    iter = iter + 1;
    
end
