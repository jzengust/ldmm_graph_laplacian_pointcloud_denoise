function [p]=barylag2d(f, xn, yn, xf, yf)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% barylag2d.m
%
% Interpolates the given data using the Barycentric Lagrange Interpolation 
% formula on the unit square. Vectorized to remove all loops
%
% Reference:
%
% (1) Jean-Paul Berrut & Lloyd N. Trefethen, "Barycentric Lagrange 
%     Interpolation" 
%     http://web.comlab.ox.ac.uk/oucl/work/nick.trefethen/berrut.ps.gz
% (2) Walter Gaustschi, "Numerical Analysis, An Introduction" (1997) pp. 94-95
% (3) Eugene Isaacson and Herbert Bishop Keller, "Analysis of Numerical
%     Methods", Dover Edition (1994) p. 295
%
% Written by: Greg von Winckel       07/16/04
% Contact:    gregvw@chtm.unm.edu 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[M,N]=size(f);

xn=xn(:); xf=xf(:); yn=yn(:); yf=yf(:);
Mf=length(xf);      Nf=length(yf);

if or(length(xn)~=M,length(yn)~=N)
    error('grid and data size do not match');
end

% Compute the barycentric weights
X=repmat(xn,1,M);   Y=repmat(yn,1,N);

% matrix of weights
Wx=repmat(1./prod(X-X.'+eye(M),1),Mf,1);
Wy=repmat(1./prod(Y-Y.'+eye(N),1),Nf,1);

% Get distances between nodes and interpolation points
xdist=repmat(xf,1,M)-repmat(xn.',Mf,1);
ydist=repmat(yf,1,N)-repmat(yn.',Nf,1);

% Find all of the elements where the interpolation point is on a node
[xfixi,xfixj]=find(xdist==0);
[yfixi,yfixj]=find(ydist==0);

% Approximate zeros (easier than exact substitution in 2D)
xdist(xfixi,xfixj)=eps; ydist(yfixi,yfixj)=eps;

Hx=Wx./xdist;
Hy=Wy./ydist;

% Interpolated polynomial
p=(Hx*f*Hy.')./(repmat(sum(Hx,2),1,Nf).*repmat(sum(Hy,2).',Mf,1));
