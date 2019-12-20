% to reorient normals, only for center of the patch
% input the normal to be reoriented, and also the patch connection
% Jin Zeng, 20170707

function re_normal = reorient_n(in_normal, P_win)
pn = size(P_win, 1);
u = randsample(pn,1);
d = ones(pn,1); % label of discovered or not, 0 for discovered and -1 for undiscovered
sq = zeros(pn,1); % queue, with length n
sqh = 0; sqt = 0; % queue head/tail
sqt = sqt+1; sq(sqt)=u; % push in the STARTING point
d(u) = 0;

re_normal = in_normal;
while sqt-sqh>0 % if not empty
    sqh = sqh+1;
    v = sq(sqh); % pop v off the head of the queue   
    wedge = P_win(v,:); % search the neighbors of v
    for i = 1:length(wedge)
        w = wedge(i);
        if d(w) % if not discovered
            sqt = sqt+1; sq(sqt) = w; % push into the queue
            d(w) = 0; % mark as discovered
            if re_normal(w,:)*re_normal(v,:)' < 0
                re_normal(w,:) = -re_normal(w,:);
            end
        end
    end
end
end