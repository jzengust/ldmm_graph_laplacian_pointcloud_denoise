% Function for denoising
% input: noisy X, noise level
% output: save each iteration, mse for each iteration
%
% This code is for the following paper:
% 	3D Point Cloud Denoising Using Graph Laplacian Regularization of a Low Dimensional Manifold Model
% 	@article{zeng20183d,
%  	 title={3D Point Cloud Denoising using Graph Laplacian Regularization of a Low Dimensional Manifold Model},
%  	 author={Zeng, Jin and Cheung, Gene and Ng, Michael and Pang, Jiahao and Yang, Cheng},
%  	 journal={arXiv preprint arXiv:1803.07252},
%  	 year={2018}
% 	}
% Last Update: Jin Zeng, 20190412

function dM = pcdGLR(X, X_gt, noise_level, shapename)

current_dataset_folder = [shapename '\' num2str(noise_level)];
if ~exist(current_dataset_folder, 'dir')
    mkdir(current_dataset_folder);
end

%% parameter settings
max_itr = 20; change_tolerance = 0.00005; % stop criteria
% choose fps for uniform sampling
flag_sample = 1; SAMPLING_SET = ceil(0.5*size(X,1));
% if not, use grid sample
gridStep = 0.7;
% patch size, searching window size,
pk = 30; wink = 16;
% graph construction parameter: epsilon, patch similarity threshold
eps1 = 0.03*ones(max_itr,1); eps1(1:2)=[0.07, 0.04]; eps1 = eps1.^2;
threshold_d = 1;
% optimization parameter, lambda_b = 4,7,12 for 0.02,0.03,0.04
gamma=0.5;
lambda_a = 25; lambda_b = lambda_setting(noise_level);
lambda = lambda_a*(exp((1:max_itr)/lambda_b)-1);

%% pixel graph (no prefiltering now)
X_m = X;

%% patch center, patch construction with size=pk, and patch graph with k=wink
pt_pre = pointCloud(X);
% patch center
if flag_sample
    srf = struct('X',X(:,1),'Y',X(:,2),'Z',X(:,3));
    ifps = fps_euc(srf,SAMPLING_SET);
    pt_C = pointCloud(X(ifps,:));
else
    pt_C = pcdownsample(pt_pre,'gridAverage',gridStep);
end
% patch construction
pn = pt_C.Count; % patch number
P = zeros(pn,pk); % patch center and the node indices in the patch
for i = 1:pn
    [indices,dists] = findNearestNeighbors(pt_pre,pt_C.Location(i,:),pk);
    P(i,:) = indices;
end
Nf = pn*pk; % node graph size
% patch graph
P_win = zeros(pn, wink);
for i = 1:pn
    [indices,dists] = findNearestNeighbors(pt_C,pt_C.Location(i,:),wink);
    P_win(i,:) = indices;
end
P_win = P_win(:,2:end);

%% Denoising
dM = zeros(max_itr,1);
X_pre = X;
% set center
X_c = zeros(pn,3);
for c = 1:3
    u = X_pre(:,c);
    X_c(:,c) = mean(u(P),2);
end

for itr = 1:max_itr
    %% prepare reference frame for each patch: so as to compute height field and projection
    % shift the point wrt the center
    f = zeros(pn,pk,3); fo = f;
    for c = 1:3
        u = X_m(:,c);
        f(:,:,c) = u(P)-repmat(X_c(:,c),1,pk);
        u = X_pre(:,c);
        fo(:,:,c) = u(P)-repmat(X_c(:,c),1,pk);
    end
    % normal at each center
    fn = zeros(pn,3); ptmp = zeros(pk,3);
    for i = 1:pn
        ptmp(:,:) = f(i,:,:);
        cov = ptmp'*ptmp;
        [Vtmp,Dtmp] = eig(cov);
        fn(i,:) = Vtmp(:,1); % reference plane with normal vertor stored in fn
    end
    
    %% patch similarity and connection
    D_i = zeros(Nf,wink-1);D_w = zeros(Nf,wink-1); tmp_p1 = (1:pk)';
    % temp variable for comparing fixed and moving patches
    fixed = zeros(pk,3); fixed_n = zeros(3,1); moving = fixed;
    for i = 1:pn
        % load fixed
        fixed(:,:) = f(i,:,:); fixed_n(:) = fn(i,:);
        % compute height field, and projection on reference plane
        hf = fixed*fixed_n; fixed_proj = fixed-hf*fixed_n';
        % search the neighbors of fixed
        wedge = P_win(i,:);
        for j = 1:length(wedge)
            % load moving
            w = wedge(j); moving(:,:) = f(w,:,:);
            % height field and projection on plane
            hm = moving*fixed_n; moving_proj = moving-hm*fixed_n';
            % use projection for neighbor search
            xx = sum((fixed_proj.^2),2);
            yy = sum((moving_proj.^2),2);
            xy = fixed_proj*moving_proj';
            DistMat = repmat(xx,1,length(yy))-2*xy+repmat(yy',length(xx),1);
            [dmin, idx] = min(DistMat,[],2);
            % find interpolation nodes
            preserve_id = dmin<=threshold_d; discard_id = dmin>threshold_d;
            Dsum = 0;
            if sum(discard_id)
                tempid = find(discard_id);
                if sum(discard_id) > 1
                    [~, IDistMat] = sort(DistMat(discard_id,:),2);
                    for ii = 1:length(tempid)
                        tmp_pt = tempid(ii);
                        dx = interpolate_plane(moving(IDistMat(ii,1),:),moving(IDistMat(ii,2),:),moving(IDistMat(ii,3),:),fixed(tmp_pt,:),fixed_n');
                        Dsum = Dsum+dx^2;
                    end
                else
                    [~, IDistMat] = sort(DistMat(discard_id,:));
                    dx = interpolate_plane(moving(IDistMat(1),:),moving(IDistMat(2),:),moving(IDistMat(3),:),fixed(tempid,:),fixed_n');
                    Dsum = Dsum+dx^2;
                end
            end
            % use height field for computing distance
            Dist = (sum((hm(idx(preserve_id))-hf(preserve_id)).^2)+Dsum)/pk;
            D_w(pk*(i-1)+tmp_p1,j) = Dist;
            D_i(pk*(i-1)+tmp_p1,j) = pk*(w-1)+idx(:);
        end
    end
    tmp = repmat((1:Nf)',1,wink-1);
    D_p = sparse(tmp(:),D_i(:),D_w(:),Nf,Nf);
    
    %% laplacian construction
    %  mean_p = sum(sum(D_p))/sum(sum(D_p>0));
    A = D_p; A(A>0.5) = 0;
    %     mask1 = logical(tril(A, -1)); mask2 = logical(triu(A, 1));
    %     mask = mask1'.*mask2; mask = mask+mask;
    %     A = A.*mask; A = 0.5*(A+A');
    mask1 = logical(tril(A));
    A = A-mask1'.*A;
    A = A+A';
    A(A>0)=exp(-A(A>0)./(2*eps1(itr)));
    weight_rec=diag(sum(A).^(-gamma));
    A=weight_rec*A*weight_rec;
    Dn=sum(A);
    Dn=diag(Dn);
    L=Dn-A;
    
    %% optimize
    X_rec = zeros(length(X_pre),3);
    tmp = P';
    U = sparse(1:Nf,tmp(:),ones(Nf,1),Nf,length(X_pre));
    for c = 1:3
        t = repmat(X_c(:,c),1,pk);
        t = t'; t = t(:);
        u0 = X_pre(:,c);
        C = U'*L*t+lambda(itr)*u0;
        B = U'*L*U+lambda(itr)*speye(length(X_pre));
        X_rec(:,c) = lsqr(B,double(C));
    end
    
    write_ply_only_points(X_rec,[current_dataset_folder '/' 'xrec_' num2str(itr) '.ply']);
    dM(itr,1) = meandistance(X_gt, X_rec);
%     change_dM = meandistance(X_pre, X_rec);
    disp(num2str(dM(itr,1)));
%     disp([num2str(dM(itr,1)) ', ' num2str(change_dM)]);
    if itr>1
        if dM(itr,1) >= dM(itr-1,1) % terminate if it doesn't decrease
            disp('early terminate: mse')
            break;
        end
    end
%     if change_dM < change_tolerance % terminate if it doesn't change too much
%         disp('early terminate')
%         break;
%     end
    X_pre = X_rec;
    X_m = X_pre;
end

savestr = [current_dataset_folder '/' num2str(noise_level) '_' shapename '_MSE.mat'];
clearvars -except dM savestr shapename noise_level
save(savestr);

end