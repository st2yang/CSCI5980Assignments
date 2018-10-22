function [R,C] = projection2RC(P)

R = P(:,1:3);
C = -R'*P(:,4);

end