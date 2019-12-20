function [Dist, distMat, n_idx] = pcdist(sample, reference)
% calculate the euclidean distance for every point in sample point cloud to 
% the closest point in the reference point cloud (number of columns must
% match)

% INPUT: 
%     reference, the pointCloud
%     sample   , the fixed pointCloud

% OUTPUT:
%     Dist      = scalar
%     distMat   = P x K vector
%     n_idx     = P x K vector

n_sample = length(sample.Location);

K = 1;
distMat = zeros(n_sample,K);
n_idx = zeros(n_sample,K);
Lref = reference.Location;
Lsample = sample.Location;
n_ref = length(Lref);
for row_idx = 1:n_sample
    %[indices,dists] = findNearestNeighbors(reference,sample.Location(row_idx,:),K,'Sort',true);
    [dists, indices] = min(sum((Lref - repmat(Lsample(row_idx,:),n_ref,1)).^2, 2));
    distMat(row_idx,:) = dists';
    n_idx(row_idx,:) = indices';
end
Dist = mean(distMat(:,1));
end