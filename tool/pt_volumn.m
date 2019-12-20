% compute the pointcloud volumn
% input the N*3 matrix for point cloud locations
% 20170612, Jin Zeng

function vol = pt_volumn(X)
  xrange = max(X(:,1))-min(X(:,1));
  yrange = max(X(:,2))-min(X(:,2));
  zrange = max(X(:,3))-min(X(:,3));
  vol = xrange*yrange*zrange;
end