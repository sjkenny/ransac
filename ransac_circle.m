% ransac optimized circle fitting 
% parameters
% mapping: mol -> CatInd -> ind -> inlier_idx

addpath ../common
radius=100;
PxSize=160;
FindCat=2;
threshDist=50;
score_thresh=50;

[r,filehead]=OpenMolListTxt;

CatInd=find(r.cat==FindCat);

x=PxSize*r.xc(CatInd);
y=PxSize*r.yc(CatInd);
X = [x y];
[count edges mid loc] = histcn(X);
nbins = max(loc);
ind_list_final = [];

% iterate through bins for local searching
FindRings=0;
for i=1:nbins(1)
    for j=1:nbins(2)
        fprintf('bin %d,%d \r', i, j)
        ind = find(loc(:,1)==i & loc(:,2)==j);
        xList = x(ind);
        yList = y(ind);       
        N=numel(xList);             
        BestScore=0;
        BestInd=[]; 
        ind_out = [];
        % find all the rings in the ROI- find best ring, add indices, then
        % loop
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
            %terminate while loop

        end
        FindRings=0;
        ind_list_final = [ind_list_final; ind_out];
    end
end

ind_final = CatInd(ind_list_final);
r.cat(ind_final) = r.cat(ind_final)+1;
   
outfile=sprintf('%s-ring.bin',filehead);
WriteMolBinNXcYcZc(r,outfile);


    