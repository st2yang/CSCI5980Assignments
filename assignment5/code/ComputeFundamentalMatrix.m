function [F, ssign] = ComputeFundamentalMatrix(u, v)
%% v'Fu = 0 where v is from the right image, u from the left

if (size(u,2) ~= 2 || size(u,2) ~= 2) %ensure u, v are nx2 stacked vectors
    x1 = u';
    x2 = v';
else
    x1 = u;
    x2 = v;
end

A = [];
for i = 1 : size(x1,1)
    A =[A; x1(i,1)*x2(i,1), x1(i,2)*x2(i,1), x2(i,1),...
           x1(i,1)*x2(i,2), x1(i,2)*x2(i,2), x2(i,2),...
           x1(i,1),         x1(i,2),         1];
end

%% solve for A*f = 0;
[U, D, V] = svd(A);
f = V(:,end);
F_temp = [f(1:3)';f(4:6)';f(7:9)'];

%% Cleanup
[Uf,Df,Vf] = svd(F_temp);
newD =  [1,0,0;...
         0,1,0;...
         0,0,0];
     
%check if degenerate
if(Df(2,2)<0.0001)
    F = newD*1e3;%some bad value
    ssign = 1;
else
    newD = Df; newD(3,3)=0;
    F = Uf*newD*Vf';
    assert(rank(F) ==2);
    ssign = 0;
end
