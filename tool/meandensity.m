function [density,density_std] = meandensity(A, nn)

dM1 = pdist2(A,A,'euclidean','Smallest',nn);
dM = mean(dM1(2:end,:),1);
density = mean(dM);
density_std = std(dM);
end