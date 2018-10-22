function reproject_visualization_allidx(Y_s,Ia,R1,C1,u1)
% function reproject_visualization(Y_s,K,Ia,Ib,R1,C1,R2,C2,u1,u2)

global K;

idx_x = Y_s(:,1) ~= -1;
idx_u = u1(:,1) ~= -1;
id = idx_x & idx_u;

Y_s = Y_s(id,:);
u1 = u1(id,:);

u1 = normalized2pixel(u1);
 
u_tl = K*R1*[eye(3) -C1]*[Y_s';ones(1,size(Y_s,1))];
u_tl = u_tl(1:2,:)./u_tl(3,:);
u_tl = u_tl';
figure();
imshow(Ia);
hold on;
scatter(u1(:,1),u1(:,2),'b','o');
hold on;
scatter(u_tl(:,1),u_tl(:,2),'r','x');

% v_tl = K*R2*[eye(3) -C2]*[Y_s';ones(1,size(Y_s,1))];
% v_tl = v_tl(1:2,:)./v_tl(3,:);
% v_tl = v_tl';
% figure();
% imshow(Ib);
% hold on;
% scatter(u2(:,1),u2(:,2),'b','o');
% hold on;
% scatter(v_tl(:,1),v_tl(:,2),'r','x');

end