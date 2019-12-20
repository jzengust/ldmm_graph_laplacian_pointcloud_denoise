% Flip the normal direction
% input: sensor location, position, normal
% output: flipped normal
% Jin Zeng, 20170526

function n_flip = reorient_normal(sensor, p, n)
N = size(p,1);
p1 = repmat(sensor,N,1) - p;
inner_product = (p1.*n)*ones(3,1);
n_flip = n;
n_flip(inner_product < 0,:) = - n(inner_product < 0,:);
end