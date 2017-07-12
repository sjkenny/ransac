%ransac circle function
%returns center, score
%fixed radius?
%pxsize?

function [t_hist, r_hist, center, BestScore, best_radius] = ransac_ring(x,y)
addpath ../common

%%
PxSize = 160;
% radius = 80;
threshDist = 40;
radius_range = 300;
radius_mean = 80;

% radius_min = radius_mean-radius_range/2;

radius_min = 1; %radius = 1:300
x1=x.*PxSize;
y1=y.*PxSize;
xRange = 400;
yRange = 400;
xMin=1400;
yMin=1400;
n_iter = 10000;
BestScore = 0;
for k=1:n_iter
    radius = (rand(1)*radius_range)+radius_min;
    x_center = (rand(1)*xRange)+xMin;
    y_center = (rand(1)*yRange)+yMin;
    Dist = sqrt((x1-x_center).^2+(y1-y_center).^2);
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
%other parameters for log reg - center around fitted ring and do radial
%histogram
x1=x1-center(1);
y1=y1-center(2);
[theta, r] = cart2pol(x1,y1);
r_bins = 0:100:1000;
t_bins = -pi:pi/6:pi;
t_hist = hist(theta,t_bins);
r_hist = hist(r,r_bins);

% [a,b] = hist_edge(x,y,'bin_length',1,'img_size',6);

% figure
% plot(x,y,'k.')
% hold on
% plot(x(BestInd),y(BestInd),'m.')