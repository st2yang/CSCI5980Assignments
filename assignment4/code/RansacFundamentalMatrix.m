function [Best_Fmatrix,maxInliers] = RansacFundamentalMatrix(matches_a, matches_b)

ptsPerItr = 8;
maxInliers_size = 0;
errThreshold = 0.008;

Best_Fmatrix = zeros(3,3);
xa = [matches_a ones(size(matches_a,1),1)];
xb = [matches_b ones(size(matches_b,1),1)];

for i = 1:1000
    ind = randi(size(matches_a,1), [ptsPerItr,1]);
    FmatrixEstimate = ComputeFundamentalMatrix(matches_a(ind,:), matches_b(ind,:));   
    err = sum((xb .* (FmatrixEstimate * xa')'),2);
    inliners = find(abs(err) <= errThreshold);
    inliners_size = size(inliners, 1);
    if (inliners_size > maxInliers_size)
       maxInliers = inliners;
       Best_Fmatrix = FmatrixEstimate; 
       maxInliers_size = inliners_size;
    end    
end

maxInliers_size

end