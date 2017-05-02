
%ransac_line

addpath ../common
radius=100;
PxSize=160;
FindCat=1;
threshDist=50;
score_thresh=150;

num_iter = 500;
KeepGoing = 1;
[r,filehead]=OpenMolListTxt;

CatInd=find(r.cat==FindCat);

x=PxSize*r.xc(CatInd);
y=PxSize*r.yc(CatInd);
X = [x y];
xMax = max(x);
yMax = max(y);
xMin = min(x);
yMin = min(y);
count =1;
while KeepGoing == 1;
    BestScore = 0;
    BestInd=[];
    p_num = length(X);
    d=[];
    for k=1:num_iter
        if ~mod(k,100)
            fprintf(1,'Current Iteration:%d\n',k)
        end

        ind_1 = ceil(rand*p_num);
        ind_2 = ceil(rand*p_num);
        Q1 = X(ind_1,:);
        Q2 = X(ind_2,:);
        for i=1:p_num
             d(i) = abs(det([Q2-Q1;X(i,:)-Q1]))/norm(Q2-Q1);
    %     d = abs(bsxfun(@cross,(Q2-Q1),(bsxfun(@minus,X,Q1))))/abs(Q2-Q1);
    %     DistSq = ((xList-x_center).^2+(yList-y_center).^2);
    %     DistSq = DistSq-(radius.^2);
        end
        inlier_idx = find(d<threshDist);
        score = numel(inlier_idx);
        score_list(k) = BestScore;
        % if new best score is achieved, first test to see if it's
        % above threshold - if so, add indices to running list, and
        % delete from source list - if not, break loop
        if score>BestScore
            BestScore = score;
            line_points = [Q1 Q2];

            if score>=score_thresh                   
                BestInd = inlier_idx;                                            
            end
        end               
    end
    if BestScore<score_thresh
        KeepGoing = 0;
        break
    end
    figure
    plot(x,y,'k.')
    hold on
    plot(X(BestInd,1),X(BestInd,2),'m.')
    plot(line_points(:,1),line_points(:,2),'g','MarkerSize',3)
    hold off 
    X(BestInd,:)=[];
    count=count+1;
end
% clf
% plot(x,y,'k.')
% hold on
% plot(x(BestInd),y(BestInd),'m.')
% plot(line_points(:,1),line_points(:,2),'g','MarkerSize',3)
% hold off
% figure
% kk=1:num_iter;
% plot(kk,score_list)