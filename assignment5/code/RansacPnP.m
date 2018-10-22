function [Best_R,Best_C] = RansacPnP(u_in,X_in)
% u is in pixel coordinate

global K;

bool_u = u_in(:,1) ~= -1;
bool_X = X_in(:,1) ~= -1;

bool = bool_u & bool_X;

u = u_in(bool,:);
X = X_in(bool,:);

ptsPerItr = 6;
maxInliers_size = 0;
errThreshold = 0.0008;

Best_R = zeros(3,3);
Best_C = zeros(3,1);

while (maxInliers_size < ptsPerItr+1)
    for i = 1:1000
        
        ind = randi(size(X,1), [ptsPerItr,1]);
        [R_est,C_est] = LinearPnP(u(ind,:),X(ind,:));
        
        u_reproj = R_est*(X-C_est')';
        u_reproj = u_reproj(1:2,:)./u_reproj(3,:);
        u_reproj = u_reproj';
        
        err = u-u_reproj;
        
        inliners = find(abs(err) <= errThreshold);
        inliners_size = size(inliners, 1);
        
        if (inliners_size > maxInliers_size)
            maxInliers = inliners;
            Best_R = R_est;
            Best_C = C_est;
            maxInliers_size = inliners_size;
        end
        
    end
end

maxInliers_size_ransacpnp = maxInliers_size;
maxInliers_size_ransacpnp

% TODO: sign of R
if round(det(Best_R)) == -1
    
    Best_R = -Best_R;
%     Best_C = -Best_C;
    
end

% reproject_visualization(X,Ia,Best_R,Best_C,normalized2pixel(u));

end