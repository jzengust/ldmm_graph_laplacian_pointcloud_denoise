% Main addnoise to GT
% noise level: 0.02, 0.03, 0.04
%
% This code is for the following paper:
% 	3D Point Cloud Denoising Using Graph Laplacian Regularization of a Low Dimensional Manifold Model
% 	@article{zeng20183d,
%  	 title={3D Point Cloud Denoising using Graph Laplacian Regularization of a Low Dimensional Manifold Model},
%  	 author={Zeng, Jin and Cheung, Gene and Ng, Michael and Pang, Jiahao and Yang, Cheng},
%  	 journal={arXiv preprint arXiv:1803.07252},
%  	 year={2018}
% 	}
% Last update: Jin Zeng 20190412

clear; close all; clc
addpath './tool'

is_shapenet = 0;
if is_shapenet% for shapenet
    path_in = './meshlab/shapenet_sampling/output/';
    path_out = './meshlab/shapenet_sampling/noisy/';
else
    path_in = './3d_data_set/gt/';
    path_out = './3d_data_set/noise/';
end
noise_level = {'0.02', '0.03', '0.04'};
dataset = {'anchor'};

for i=1:numel(dataset)
    model_path = [path_in dataset{i} '_GT.ply'];
    pt_gt = pcread(model_path);
    X_gt = pt_gt.Location;
    for iii = 0.02:0.01:0.04 % generate noisy ply with sigma=0.02, 0.03, 0.04
        options = [];
        defaults=struct('GaussianNoise',iii,... % parameters below are not used           
            'ShotNoiseProbability',[0 0],...  % create model with holes
            'ShotNoiseNumber',[10 100],...
            'ShotNoiseMagnitude',[1 1]*0.2,...
            'DepthShotNoiseProbability',0,... % create model with shot noise
            'DepthShotNoiseMagnitude',0.2,...
            'DepthShotNoiseNumber',100,...
            'CameraCenter',[ 0 0 -6]); % optical center for GIP camera
        options=incorporate_defaults(options,defaults);        
        X = addnoise(X_gt, [path_out dataset{i}], options);
    end
end