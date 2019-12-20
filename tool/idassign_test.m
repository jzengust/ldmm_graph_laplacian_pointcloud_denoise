% Test the assignment
% flag_gt: use ground truth for assigning the index
% flag_avg: use the standard patch; use fixed_pre if it is model 2
% otherwise: use the random initial patch
% Jin Zeng, 20170707

function I_p = idassign_test(f,fgt,fixed_pre,P_win,flag_gt,flag_avg, flag_model)
pn = size(f,1); pk = size(f,2);
I_p = zeros(pn,pk);

u = randsample(pn,1);
d=-1*ones(pn,1); % label of discovered or not, 0 for discovered and -1 for undiscovered
sq=zeros(pn,1); % queue, with length n
sqh=0; sqt=0; % queue head/tail
sqt=sqt+1; sq(sqt)=u; % push in the STARTING point
d(u)=0;
I_p(u,:) = 1:pk;
while sqt-sqh>0 % if not empty
    sqh=sqh+1;
    v=sq(sqh); % pop v off the head of the queue
    fixed = zeros(pk,3);
    if flag_gt
        fixed(:,:) = fgt(u,:,:);
        if flag_model == 2
            fixed(:,:) = fixed_pre;
        end
    else
        if flag_avg
            fixed(:,:) = fgt(u,:,:);
            if flag_model == 2
                fixed(:,:) = fixed_pre;
            end
        else
            fixed(:,:) = f(u,:,:);
        end
    end
    
    moving = zeros(pk,3);
    wedge = P_win(v,:); % search the neighbors of v
    for i = 1:length(wedge)
        w = wedge(i);
        if d(w)<0 % if not discovered
            sqt=sqt+1; sq(sqt)=w; % push into the queue
            d(w)=0; % mark as discovered
            if flag_gt
                moving(:,:) = fgt(w,:,:);
            else
                moving(:,:) = f(w,:,:);
            end
            xx = sum((fixed(:,:).^2),2);
            yy = sum((moving(:,:).^2),2);
            xy = fixed(:,:)*moving(:,:)';
            costMat = repmat(xx,1,length(yy))-2*xy+repmat(yy',length(xx),1);
            [idx,~] = munkres(costMat);
            %Dist = cost/length(xx);
            I_p(w,idx) = I_p(u,:);
            %D_p = D_p+sparse(pk*(v-1)+repmat(1:pk,1,K2),pk*(w-1)+idx(:),Dist*ones(K2*pk,1),Nf,Nf);
        end
    end
end