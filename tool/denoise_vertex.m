function X_m = denoise_vertex(X_gt, X, K, eps, lambda)

N = length(X);
[idx, dist] = knnsearch(X,X,'k',K);
I = repmat((1:N)', 1, K);
D = sparse(I(:), idx(:), double(dist(:)), N, N);

A = D.^2;
A(A>0) = exp(-A(A>0)./(2*eps^2));
mask1 = logical(tril(A));
A = A-mask1'.*A;
A = A+A';
weight_rec=diag(sum(A).^(-0.5));
A=weight_rec*A*weight_rec;
Dn=sum(A);
Dn=diag(Dn);
L=Dn-A;

X_m = zeros(N,3);
for c = 1:3
    C=lambda*double(X(:,c));%C=lambda*A*double(X(:,c));
    B=L+lambda*speye(N); %B=L+lambda*A;
    X_m(:,c)=lsqr(B,C);%X_rec(:,c)=B\A; % this is to solve the optimization problem
end

dM = meandistance(X_gt, X_m)

end