function X = LinearTriangulation(P1,u,P2,v)

u = [u ones(size(u,1),1)];
v = [v ones(size(v,1),1)];

A = [];
for i=1:size(u,1)
   
    A_t = skewsymm(u(i,:))*P1;
    A = [A;A_t(1:2,:)];
    
end
for j=1:size(v,1)
   
    A_t = skewsymm(v(j,:))*P2;
    A = [A;A_t(1:2,:)];
    
end

[~,~,V] = svd(A);
X = V(:,end);

X = X(1:3,1)/X(4,1);
% X = X(1:3,1);

end