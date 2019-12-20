function [res]=fps_euc(surface,N)
current_idx=1;
res=zeros(1,min(numel(surface.X),N));
d=inf([1,length(surface.X(:))]);
t1=cputime;
for i = 1:N
    t2=cputime;
    if ((t2-t1)>5)
        fprintf('fps: %f\n',i/N);
        t1=cputime;
    end
    
    d2=pdist2([surface.X(current_idx),surface.Y(current_idx),surface.Z(current_idx)],[surface.X,surface.Y,surface.Z])';
    d=min(d,d2');
    res(i)=current_idx;
    [~,current_idx]=max(d,[],2);
end
end