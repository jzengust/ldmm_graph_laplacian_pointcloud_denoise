function dx = interpolate_plane(A,B,C,X,n0)
AB = B-A;
AC = C-A;
n = cross(AB,AC);
%n = n/norm(n);
d = -n*A';
dx = -(d+X*n')/(n0*n'); % output the height of X along n0, against the plane ABC
end