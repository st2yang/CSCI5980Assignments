function idx = CheckCheirality(Y,C1,R1,C2,R2)

a = (Y-C1')*R1(3,:)';
idx1 = find(a > 0);

b = (Y-C2')*R2(3,:)';
idx2 = find(b > 0);

idx = intersect(idx1,idx2);

end