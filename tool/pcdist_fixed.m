function [Dist, n_idx] = pcdist_fixed(fixed, moving)
% calculate the squared euclidean distance for every point in fixed point cloud to 
% the closest point in the moving point cloud (number of columns must
% match)

% INPUT: 
%     fixed, the pointCloud
%     moving , the fixed pointCloud

% OUTPUT:
%     Dist      = scalar
%     n_idx     = P x 1 vector

n_fixed = length(fixed);
n_moving = length(moving);
D = zeros(n_fixed, n_moving);
for c = 1:3
    u1 = fixed(:,c); u2 = moving(:,c);
    D = D+(repmat(u1,1,n_moving)-repmat(u2',n_fixed,1)).^2;
end
[Dist, n_idx] = min(D,[],2);
Dist = mean(Dist);
end