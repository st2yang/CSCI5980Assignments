function [R,C] = LinearPnP(u,X)

A = [];

for i = 1:size(X,1)
   
    x = X(i,1);
    y = X(i,2);
    z = X(i,3);
    
    u_x = u(i,1);
    u_y = u(i,2);
    
    A = [A;
         x y z 1 0 0 0 0 -u_x*x -u_x*y -u_x*z -u_x;...
         0 0 0 0 x y z 1 -u_y*x -u_y*y -u_y*z -u_y];
    
end

[~,~,v] = svd(A);
p = v(:,end);

P = [p(1:4)';p(5:8)';p(9:12)'];

[u,d,v] = svd(P(:,1:3));

R = u*v';
la = 1/d(1,1);
t = la*P(:,4);

C = -R'*t;

% if round(det(R)) == -1
%     
%     R = -R;
%     C = -C;
%     
% end

end