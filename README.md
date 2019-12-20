## 3D Point Cloud Denoising Using Graph Laplacian Regularization of a Low Dimensional Manifold Model

by Jin Zeng, Gene Cheung, Michael Ng, Jiahao Pang, Cheng Yang

To appear on IEEE Trans. on Image Processing

## Organization
	|--- main_addnoise.m : main for adding noise to gt
	|--- main_glr.m : main for GLR denoising
	|--- pcdGLR.m : function for GLR denoising
	|--- tool : tools for GLR
	|--- metric : for computing MSE
	|--- setParameter : for parameter setting
	|--- 3d_data_set : sample point cloud model "anchor"
		|--- gt : ground truth
		|--- noise : noisy input with noise level 0.02, 0.03, 0.04
	|--- anchor : denoising output for "anchor"
	|--- README.md : intrustructions


## Dependency
The code is tested with MATLAB R2016a.

## Demo
1. run **main_addnoise.m** to get noise corrupted point cloud in ./3d_data_set/noise
2. run **main_glr.m** to get denoising results in ./anchor

## Citation
If our work is useful for your research, please consider citing:

        @inproceedings{zeng20183d,
          title={3d point cloud denoising using graph laplacian regularization of a low dimensional manifold model},
          author={Zeng, Jin and Cheung, Gene and Ng, Michael and Pang, Jiahao and Yang, Cheng},
          booktitle={arXiv preprint arXiv:1803.07252},
          year={2018}
        } 

## Contact 
Jin Zeng, jzengab@connect.ust.hk
