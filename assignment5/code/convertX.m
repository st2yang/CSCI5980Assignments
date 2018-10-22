function X1 = convertX(X)

X1 = zeros(4,size(X,1));

idx = find(X(:,1) ~= -1);

X1(1:3,:) = X';
X1(4,idx) = ones(1,length(idx));

end