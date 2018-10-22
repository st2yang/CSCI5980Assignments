function F = ComputeFundamentalMatrix(u, v)

N = size(u,1);
A = [];
for i = 1:N
    
    ut_x = u(i,1);
    ut_y = u(i,2);
    vt_x = v(i,1);
    vt_y = v(i,2);
    
    A = [A;...
        ut_x*vt_x,ut_y*vt_x,vt_x,ut_x*vt_y,ut_y*vt_y,vt_y,ut_x,ut_y,1];
    
end

[~,~,v] = svd(A);
f = v(:,end);

F = [f(1:3)'; f(4:6)'; f(7:9)'];

[u,d,v] = svd(F);
d(3,3) = 0;
F = u*d*v';

end