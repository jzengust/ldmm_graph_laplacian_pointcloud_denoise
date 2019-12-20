%% Mean Distance: average euclidean distance between two point clouds.
% Let A and B be subsets of a metric space (Z,dZ),
% The D_mean distance between A and B, denoted by dD (A, B), is defined by:
% dD (A, B) = mean{mean dz(a,B), mean dz(b,A)}, for all a in A, b in B,
% dD(A, B) = mean(d(A, B),d(B, A)),
% where d(A, B) = mean(min(d(a, b))),
% and d(a, b) is a L2 norm.
% dM = meandistance( A, B )
% A: First point sets.
% B: Second point sets.
% ** A and B may have different number of rows, but must have the same number of columns. **
% Jin Zeng, 20170525
%%
function dM = meandistance(A, B)
if(size(A,2) ~= size(B,2))
    fprintf( 'WARNING: dimensionality must be the same\n' );
    dM = [];
    return;
end
%dM = 0.5*(compute_dist(A, B)+compute_dist(B, A));
dM1 = mean(pdist2(A,B,'euclidean','Smallest',1));
dM2 = mean(pdist2(B,A,'euclidean','Smallest',1));
dM = 0.5*(dM1+dM2);
end

%% Compute distance
function dist = compute_dist(A, B)
m = size(A, 1);
n = size(B, 1);
dim = size(A, 2);
Dist = zeros(m,1);
for k = 1:m
    C = ones(n, 1) * A(k, :);
    D = (C-B) .* (C-B);
    D = D * ones(dim,1);
    Dist(k) = sqrt(min(D));
end
dist = mean(Dist);
end