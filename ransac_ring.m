%ransac circle function
%returns center, score
%fixed radius?
%pxsize?

function [center, BestScore, radius] = ransac_ring(x,y)
addpath ../common
PxSize = 160;
% radius = 80;
threshDist = 40;
radius_range = 100;
radius_mean = 80;

radius_min = radius_mean-radius_range/2;
x=x.*PxSize;
y=y.*PxSize;
xRange = range(x);
yRange = range(y);
xMin=min(x);
yMin=min(y);
n_iter = 10000;
BestScore = 0;
for k=1:n_iter
    radius = (rand(1)*radius_range)+radius_min;
    x_center = (rand(1)*xRange)+xMin;
    y_center = (rand(1)*yRange)+yMin;
    Dist = sqrt((x-x_center).^2+(y-y_center).^2);
    Dist = Dist-(radius);
    inlier_idx = find(Dist<(radius+threshDist)&Dist>(radius-threshDist));
    score = numel(inlier_idx);

    % if new best score is achieved, first test to see if it's
    % above threshold - if so, add indices to running list, and
    % delete from source list - if not, break loop
    if score>BestScore
        BestScore = score;
        center = [x_center y_center];
        BestScore = score;
%         if score>=score_thresh                   
        BestInd = inlier_idx;                                            
        best_radius = radius;
    end               
end
% figure
% plot(x,y,'k.')
% hold on
% plot(x(BestInd),y(BestInd),'m.')