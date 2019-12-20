%% Create currupt version of the model
% Takes a shape filename (assumed to be of the name XXX_GT.mat), and
% creates noisy versions of it.
% options is a structure with the following optional fields:
% 'GaussianNoise' - a list of standard deviations for Gaussian additive corrupted versions of the surface. The standard deviation is expressed as a fraction of the surface' diameter
% (not used)'ShotNoiseProbability','ShotNoiseNumber','ShotNoiseMagnitude' - parameter lists for shot noise (i.e point are replaced by arbitrary 3D values. Parameter lists should be of equal size
% (not used)'DepthShotNoiseProbability','DepthShotNoiseMagnitude','DepthShotNoiseNumber' - for depth shot noise (i.e point are perturbed in the direction of the ray leading from the range scanner to the object
% (not used)'CameraCenter' - assumed camera location, for depth noise

function X = addnoise(X_gt, shapename, options)
if (exist('options','var')==0)
    options=[];
end

SAMPLING_SET=200;
srf=struct('X',X_gt(:,1),'Y',X_gt(:,2),'Z',X_gt(:,3));
% estimate diameter
ifps=fps_euc(srf,SAMPLING_SET);
Dfps=pdist2(X_gt(ifps,:),X_gt(ifps,:));
diam=sqrt(max(Dfps(:)));

% Create a Gaussian noised version of the surface
%for i=1:length(options.GaussianNoise)
    if strcmp(shapename(1:9), './meshlab')
        % for shapenet, use half of the diameter
        sig=0.5*diam*options.GaussianNoise;
    else% otherwise use full diameter
        sig=diam*options.GaussianNoise;
    end
    X=X_gt+randn(size(X_gt))*sig;     
    ply_filename=[shapename,'_gaussian_noise_',num2str(options.GaussianNoise)];        
    write_ply_only_points(X,[ ply_filename '.ply']);
%end

end

% defaults=struct('GaussianNoise',[0.00125 0.0025 0.005 0.01 ],...
%     'ShotNoiseProbability',[0 0],...
%     'ShotNoiseNumber',[10 100],...
%     'ShotNoiseMagnitude',[1 1]*0.2,...
%     'DepthShotNoiseProbability',0,...
%     'DepthShotNoiseMagnitude',0.2,...
%     'DepthShotNoiseNumber',100,...
%     'CameraCenter',[ 0 0 -6]); % optical center for GIP camera
% options=incorporate_defaults(options,defaults);