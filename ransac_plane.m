% ransac optimized plane segmentation
% parameters
addpath ../common
PxSize=160;
FindCat=1;
threshDist=50;
% select plane image first, then full mol list


[r] = OpenMolListTxt;
[r1,filehead] = OpenMolList;

CatInd=find(r.cat==FindCat);

x=double(PxSize*r.xc(CatInd));
y=double(PxSize*r.yc(CatInd));
z=double(r.zc(CatInd));

% [xMin,xMinInd]=min(x);
% [yMin,yMinInd]=min(y);
% x=x-xMin;
% y=y-yMin;
% 
% plot(x,y,'k.')
% axis equal
N=numel(x)
% select data subset, generate model
N_iter = 1000;

BestScore=0;
BestInd=[];
ScoreList=zeros(N_iter,1);
IndList=zeros(N_iter,1);
for i=1:N_iter
    
    if ~mod(i,100)
        fprintf('Iteration %d of %d \r',i,N_iter)
        fprintf('Best Score = %d \r', BestScore)
    end
    
    idx = randperm(N,3);
    xcNow = x(idx);
    ycNow = y(idx);
    zcNow = z(idx);
    AB = [xcNow(2)-xcNow(1); ycNow(2)-ycNow(1); zcNow(2)-zcNow(1)];
    AC = [xcNow(3)-xcNow(1); ycNow(3)-ycNow(1); zcNow(3)-zcNow(1)];
    norm = cross(AB,AC); % A,B,C
    A=norm(1);
    B=norm(2);
    C=norm(3);
    % plane given by Ax+By+Cz+D = 0
    D = -A*xcNow(1)-B*ycNow(1)-C*zcNow(1);
    
    P = A*x+B*y+C*z+D;
    DistSq = (P.^2)./((A.^2)+(B.^2)+(C.^2));

    inlier_idx = find(DistSq<threshDist.^2);
    score = numel(inlier_idx);
    ScoreList(i)=BestScore;
    IndList(i)=i;
    if score>BestScore
        BestScore = score;
        BestInd = inlier_idx;
        % save model parameters
        A_final=A;
        B_final=B;
        C_final=C;
        D_final=D;
    end
end

% use plane to crop image
    
    x1=PxSize.*double(r1.xc);
    y1=PxSize.*double(r1.yc);
    z1=double(r1.zc);
    % find inliers
    P = A_final*x1+B_final*y1+C_final*z1+D_final;
    DistSq = (P.^2)./((A_final.^2)+(B_final.^2)+(C_final.^2));
    inlier_idx = find(DistSq<threshDist.^2);


    
    r1.cat(inlier_idx) = r1.cat(inlier_idx)+1;    
    outfile=sprintf('%s-plane_segmentation_dist_%d_N_%d.bin',filehead,threshDist,N_iter);
    WriteMolBinNXcYcZc(r1,outfile)
    
