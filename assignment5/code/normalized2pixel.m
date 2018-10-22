function u1 = normalized2pixel(u)
% u is N by 2 pixel coordinate

global K;

u1 = [u ones(size(u,1),1)]*(K)';

u1 = u1(:,1:2)./u1(:,3);

end