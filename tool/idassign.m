function I_p = idassign(f,fixed_plane,X_cn)     
pn = size(f,1); pk = size(f,2);
I_p = zeros(pn,pk);
for i = 1:pn
    fixed(:,:) = f(i,:,:);
    fixed_n = X_cn(i,:);
    x_vector = [1 0 0]; y_vector = fixed_n; y_vector(3) = -y_vector(3);y_vector(1)=0;
    tmp_plane = [fixed*x_vector',fixed*y_vector'];
    xx = sum((fixed_plane(:,:).^2),2);
    yy = sum((tmp_plane(:,:).^2),2);
    xy = fixed_plane(:,:)*tmp_plane(:,:)';
    costMat = repmat(xx,1,length(yy))-2*xy+repmat(yy',length(xx),1);
    [idx,~] = munkres(costMat);
    %Dist = cost/length(xx);
    I_p(i,idx) = 1:pk;
end
end