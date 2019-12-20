% Interpolation test

% Demonstrates use of Barycentric Lagrange Interpolation on a rectangle
%
% Compute the first eiegenfunction of the Laplace operator on the
% unit square using a Chebyshev-tau method

N=12;

N1=N+1;
D=zeros(N1,N1);

for k=1:N
    D(k,k+1:2:N1) = 2*(k:2:N);
end

D(1,:)=D(1,:)/2;

% Chebyshev on a square (same trunation in both directions);
x=cos(pi*(0:N)/N)';
y=x;

D2=D*D;
I=eye(N1);

L=-D2;
L(N,:)=1.^(0:N);
L(N1,:)=(-1).^(0:N);

L2D=kron(L,I)+kron(I,L);

[S,E]=eig(L2D);
E=diag(E);
[val,dex]=min(E);
uhat=S(:,dex);

Uhat=reshape(uhat,N1,N1);

F=fft([Uhat(1,:); [Uhat(2:N1,:);Uhat(N:-1:2,:)]/2]);
B=real(F(1:N1,:));
G=B.';
F=fft([G(1,:); [G(2:N1,:);G(N:-1:2,:)]/2]);
U=real(F(1:N1,:)).';

[xx,yy]=meshgrid(x,y);

subplot(1,2,1),mesh(xx,yy,U);
axis tight;
axis off;

xf=linspace(-1,1,50)';
yf=linspace(-1,1,50)';

[xxf,yyf]=meshgrid(xf,yf);

Ui=barylag2d(U,x,y,xf,yf);

subplot(1,2,2),mesh(xxf,yyf,Ui);
axis tight;
axis off;