function [Xrec,Vout,Vflip,minKL] = DAD_3Dsearch(Xn,Vr,gridszA,numT,check2D)
%%%%
% Input
% Xn: training distribution: Tx2 or Tx3 matrix (if 2D, data is lifted)
% Vr: low-dim neural embedding: Nx3 matrix to align to training data (Xn)
% gridszA: number of 3d angles to search over (numAngles = gridszA^3)
% numT: number of random samples to search for translation (if numT=1, tvec = [0 0 0])
%%%%
% Example:
% [Xrec,Vout,Vflip,minKL] = DAD_3Dsearch(Xn,Vr,10,1);
% [Xrec,Vout,Vflip,minKL] = DAD_3Dsearch(Xn,Vr,10,1,1); 
% pass in fifth argument to check for 2D rotation and compare with 3D alignment

if nargin<3
    gridszA = 8;
    numT = 1;
    check2D = 0;
end

if nargin<4
    numT = 1;
    check2D = 0;
end

if nargin<5
    check2D = 0;
end

numAng = 90;

%%% grid search
tstart = tic;
Vout = gridsearch_3DKL(Xn,Vr,gridszA,numT);
telapsed = toc(tstart);
display(['Finished performing 3D alignment in ',num2str(telapsed/60,4),' minutes...'])
    
tstart = tic;
[Xrec2,Vflip2,y2,ind2] = rotated_KLmin(Vout(:,1:2),Xn(:,1:2),numAng); % alignment in 3D
telapsed = toc(tstart);
display(['Finished computing the final 2D rotation in ',num2str(telapsed/60,4),' minutes...'])
    
% run 2D and 3D DAD - pick the best (min KL)
if check2D==1
    
    [Xrec1,Vflip1,y1,ind1] = rotated_KLmin(Vr(:,1:2),Xn(:,1:2),numAng); % alignment in 2D

    % select either 2D or 3D alignment with min KL divergence 
    [~, whichest] = min( [min(y1(ind1)), min(y2(ind2))] );
    if whichest==2
        Xrec = Xrec2;
        minKL = y2(ind2);
    else
        Xrec = Xrec1;
        Vout = Vr;
        minKL = y1(ind1);
    end
    
    % return alignments from top 5 min from 3D and 2D results
    [~,sortid] = sort( [y1(ind1); y2(ind2)] );
    Vflip = cell(10,1);
    L = length(ind1);
    for i=1:10
        stid = sortid(i);
        if stid<=L
            Vflip{i} = Vflip1{stid};
        else
            Vflip{i} = Vflip2{stid-L};
        end
    end
    
else
    
    Vflip = Vflip2;
    Xrec = Xrec2;
    minKL = y2(ind2);
end
    
end % end function