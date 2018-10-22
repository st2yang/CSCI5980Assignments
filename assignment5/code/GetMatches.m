function [Mx,My] = GetMatches(I)

global K;

N = length(I);

[f_ref,d_ref] = vl_sift(single(rgb2gray(I{1})),'PeakThresh',3);

idx_ref = cell(N,1);
idxs = cell(N,1);
fs = cell(N,1);

idx_features = [];

for i = 2:N
    
    [fs{i},d_i] = vl_sift(single(rgb2gray(I{i})),'PeakThresh',3);
    [~,~,idx_ref{i},idxs{i}] = ransac_match(f_ref,d_ref,fs{i},d_i,0.7,1000);
    idx_features = union(idx_features,idx_ref{i});
    
end

Mx = -ones(size(idx_features,1),N);
My = -ones(size(idx_features,1),N);

feat_ref = pixel2normalized(f_ref(1:2,:)');
Mx(:,1) = feat_ref(idx_features,1);
My(:,1) = feat_ref(idx_features,2);

for i = 2:N
    
    feat_i = pixel2normalized(fs{i}(1:2,:)');
    [~,Locb] = ismember(idx_ref{i},idx_features);
    Mx(Locb,i) = feat_i(idxs{i},1);
    My(Locb,i) = feat_i(idxs{i},2);
    
end

end