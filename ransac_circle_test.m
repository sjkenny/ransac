%% ransac_circle_test
% asdfadsf
%%
radius=100;
PxSize=160;
FindCat=2;
threshDist=50;
score_thresh=50;

[r] = OpenMolListTxt;
xList = PxSize.*double(r.xc);
yList = PxSize.*double(r.yc);
x=xList;
y=yList;

ind_out = [];
ind_list_final = [];
FindRings=0;
ind=find(xList);
while ~FindRings
    
    BestScore=0;
    BestInd=[]; 
    for k=1:numel(xList)
        x_center = xList(k);
        y_center = yList(k);
        DistSq = ((xList-x_center).^2+(yList-y_center).^2);
        DistSq = DistSq-(radius.^2);
        inlier_idx = find(DistSq<threshDist.^2);
        score = numel(inlier_idx);

        % if new best score is achieved, first test to see if it's
        % above threshold - if so, add indices to running list, and
        % delete from source list - if not, break loop
        if score>BestScore
            BestScore = score;
            if score>=score_thresh                   
                BestInd = inlier_idx;                                            
            end
        end               
    end
    if BestScore<score_thresh
        FindRings=1;
        break
    end
    
    ind_out = [ind_out; ind(BestInd)];   
    ind(BestInd) = [];

    xList(BestInd) = [];
    yList(BestInd) = [];
    figure
    plot(x, y, 'k.')
    axis equal
    hold on
    plot(x(ind_out), y(ind_out), 'm.')
    hold off
end

%terminate while loop
% plot(x, y, 'k.')
% axis equal
% hold on
% plot(x(ind_out), y(ind_out), 'm.')
