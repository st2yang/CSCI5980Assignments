function [R1 t1 R2 t2 R3 t3 R4 t4] = tameraPose(F, K)

E = K'*F*K;

[U,d,V] = svd(E);
d(1,1) = 1;
d(2,2) = 1;
d(3,3) = 0;
E = U*d*V';

t = U(:,3);

W1 = [0 -1 0;...
      1 0 0;...
      0 0 1];

t1 = t;
R1 = U * W1 * V';
if det(R1) < 0
    R1 = -R1;
end

t2 = -t;
R2 = R1;

W2 = [0 1 0;...
      -1 0 0;...
      0 0 1];

t3 = t;
R3 = U * W2 * V';
if det(R3) < 0
    R3 = -R3;
end

t4 = -t;
R4 = R3;

end