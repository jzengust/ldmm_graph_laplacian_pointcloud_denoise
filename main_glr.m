% Main pcdGLR procedure
% Input: shapename, and gaussian noise paramter
% Output: denoised pointcloud
%
% This code is for the following paper:
% 	3D Point Cloud Denoising Using Graph Laplacian Regularization of a Low Dimensional Manifold Model
% 	@article{zeng20183d,
%  	 title={3D Point Cloud Denoising using Graph Laplacian Regularization of a Low Dimensional Manifold Model},
%  	 author={Zeng, Jin and Cheung, Gene and Ng, Michael and Pang, Jiahao and Yang, Cheng},
%  	 journal={arXiv preprint arXiv:1803.07252},
%  	 year={2018}
% 	}
% Last update: Jin Zeng, 20190412

% clear; close all; clc
addpath './tool';
addpath './metric';
addpath './setParameter';

% sample model: anchor
dataset = {'anchor'};
noise_level = {'0.02', '0.03', '0.04'};
% dM_all = zeros(20, numel(dataset), numel(noise_level)); 
path_gt = './3d_data_set/gt';
path_ny = './3d_data_set/noise';

for idset = 1:numel(dataset)
    shapename = dataset{idset};  
    for inoise = 2:numel(noise_level)   
        disp(shapename)
        disp(noise_level{inoise})
        gt_filename = [path_gt, '/', shapename,'_GT.ply'];
        filename = [shapename, '_gaussian_noise_', noise_level{inoise}, '.ply'];
        n_filename = [path_ny, '/', filename];        
        
        %% read in file for ground-truth and noisy model
        pt_gt = pcread(gt_filename);
        X_gt = pt_gt.Location;
        pt_X= pcread(n_filename);
        X = pt_X.Location;

        %% Denoising
        dM = pcdGLR(X, X_gt, noise_level{inoise}, shapename);
        dM_all(:,idset,inoise) = dM(:);
    end    
end
clearvars -except dM_all
save('GLRv2_dM.mat', 'dM_all')