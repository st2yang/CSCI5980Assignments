function [delta_x, J] = gradient_x(W,delta_z,R,C,X,M,N,lamda)

% Q = cell(M-1,1);
% C = cell(M-1,1);
% X = cell(N,1);
% we have M images and N features, therefore the Jacobian should be 2NM*(7(M-1)+3N) matrix
J = zeros(2*N*M,(6*(M-1)+3*N));

% for i=1:M-1
%     Q{i}=x((6*(i-1)+1):(6*(i-1)+4),1);
%     C{i}=x((6*(i-1)+5):(6*(i-1)+7),1);
% end
%% construct the jacobian for the camera 1 (only 3D point positions for camera 1)
for j=1:N
%     X{j}=x((7*(M-1)+3*j-2):(7*(M-1)+3*j),1);
    J((2*j-1):(2*j),(6*M+3*j-8):(6*M+3*j-6)) =Jacob_X(R{1},C{1},X{j}); % the predictive featrue of first image
end
%% construct the jacobian for the camera 2 (including Camera pose and 3D points)
for i=1:M-1  % loop by camera
    for j = 1:N 
        %J0 = MyJacobian(K,C{i},X{j},Q{i},1); % the No.j feature of No.i image
        J((2*i*N+2*j-1):(2*i*N+2*j),(6*i-5):(6*i-3)) = Jacob_Q(R{i+1},C{i+1},X{j});
        J((2*i*N+2*j-1):(2*i*N+2*j),(6*i-2):(6*i)) = Jacob_C(R{i+1},C{i+1},X{j});
        J((2*i*N+2*j-1):(2*i*N+2*j),(6*M+3*j-8):(6*M+3*j-6)) = Jacob_X(R{i+1},C{i+1},X{j});
    end
end

delta_x = -(lamda*eye(size(J,2))+J'*W*J)\(J'*W*delta_z);