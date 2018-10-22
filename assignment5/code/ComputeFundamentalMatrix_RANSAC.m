function [F,F1_in,F2_in,maxInliers] = ComputeFundamentalMatrix_RANSAC(F1, F2,thresh,ransacIter,numMatch)

% ransacIter = 1000;
% thresh = 5;
maxInliers_size = 0;
for i = 1:ransacIter
    indc = randperm(size(F1,2), 8);
    [F_iter, ssign] = ComputeFundamentalMatrix(F1(:,indc)',F2(:,indc)');
    if(ssign) %degenerate F matrix
        continue;
    else
        % Iu = Fu; Iv = F'v;
        % Sampson Epipolar Error
        err = diag([F2',ones(numMatch,1)]*F_iter*[F1;ones(1,numMatch)]);
        normdist = F_iter*[F1;ones(1,numMatch)];
        err = abs(err)./sqrt(normdist(1,:).^2+normdist(2,:).^2)';
        inlier = err < thresh;
        if(sum(inlier,1) > maxInliers_size)
            F = F_iter;
            F1_in = F1(:,inlier);
            F2_in = F2(:,inlier);
            maxInliers = inlier;
            maxInliers_size = sum(inlier,1);
        end
    end
end
assert(rank(F)==2);
e1 = null(F); e1 = e1/e1(3);
e2 = null(F'); e2 = e2/e2(3);

maxInliers_size_FRansac = maxInliers_size;
maxInliers_size_FRansac