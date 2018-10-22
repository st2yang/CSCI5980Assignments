function id_un = FindUnreconstructedPoints(X,i,j,Mx,My)

idi = (Mx(:,i) ~= -1) & (My(:,i) ~= -1);
idj = (Mx(:,j) ~= -1) & (My(:,j) ~= -1);
id_x = (X(:,1) == -1) & (X(:,2) == -1) & (X(:,3) == -1);

id_un = idi & idj & id_x;

end