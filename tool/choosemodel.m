function X_gt = choosemodel(index)
switch index
    case 1 % plane
        x = 0:0.1:10;
        y = 0:0.1:10; 
        xx = repmat(x,length(y),1);
        yy = xx';
        z = zeros(length(y),length(x));
        X_gt = [xx(:),yy(:),z(:)]; 
    case 2 % folder
        x = 0:0.1:10;
        % construct plane on xy plane
        y1 = 0:0.1:0.2; 
        xx = repmat(x,length(y1),1);
        yy = repmat(y1, length(x), 1); yy = yy';
        z = zeros(length(x),length(y1));
        X_gt = [xx(:),yy(:),z(:)];
        % and plane on xz plane
        z2 = 0.1:0.1:0.2; 
        xx = repmat(x,length(z2),1);
        zz = repmat(z2, length(x), 1); zz = zz';
        y = zeros(length(x),length(z2));
        X_gt = [X_gt;xx(:),y(:),zz(:)];
    otherwise
        disp('No such model.')
end

end