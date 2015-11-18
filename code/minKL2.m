function [YrKL, minVal, KLD, KLS, YLr, YLsc,RM,sconst] = minKL2(Y,X,C)
YLo2 = Y;
XAll = X;

cosg = cos(C.pig);
sing  = sin(C.pig);

k=ceil(size(XAll,1)^0.3);
%k=ceil(size(YLo2,1)^0.3);
dMatX=getDist(XAll,XAll);
sdMatX=sort(dMatX);
rhoX=sdMatX(k,:);

% reset k based upon number of new data points
k=ceil(size(YLo2,1)^0.3);
YLr  = cell(2*C.gnum,1);
YLsc = cell(C.anum,1);
KLD = zeros(2*C.gnum,1);

% KLS = zeros(C.anum,1);
% for p=1:C.anum
%     Ys    = C.scg(p)*YLo2;
%     KLS(p)=evalKL(XAll,Ys,k,rhoX);
% end
% 
% % rescale YLo2
% [~ , minInd]   = min( KLS );
% S1 = C.scg(minInd);
% YLo2 = S1*YLo2;

% scaleparam = C.dSzE / C.dASz;

for p=1:2*C.gnum
    pm = mod(p-1,C.gnum)+1;
    ps = 2*floor((p-1)/C.gnum)-1;
    rm = [ps,0;0,1]*[cosg(pm),-sing(pm);sing(pm),cosg(pm)];
    YLr{p} = YLo2 * rm;
    KLD(p) = evalKL(XAll,YLr{p},k,rhoX);
end

[~, minInd ]   = min( KLD );
pm = mod(minInd-1,C.gnum)+1;
ps = 2*floor((minInd-1)/C.gnum)-1;
RM = [ps,0;0,1]*[cosg(pm),-sing(pm);sing(pm),cosg(pm)];    

YrKLR  = YLr{minInd};

KLS = zeros(C.anum,1);
for p=1:C.anum
    YLsc{p} = C.scg(p)*YrKLR;
    KLS(p) = evalKL(XAll,YLsc{p},k,rhoX);
end

[minVal , minInd]   = min( KLS );
YrKL  = YLsc{minInd};
sconst = C.scg(minInd);
                    
end % end main function


function KLD = evalKL(X,Y,k,rhoX)

if nargin<4
    k=ceil(size(X,1)^0.3);
    dMatX=getDist(XAll,XAll);
    sdMatX=sort(dMatX);
    rhoX=sdMatX(k,:);
end
    
dMatT=getDist(X,Y);
[sdMatT,~]=sort(dMatT);
sdMat=sdMatT;
rhoY=sdMat(k,:);
%KLD = mean( log( rhoY ./ rhoX ) ) +log( scaleparam );
KLD = mean( log( rhoY ./ rhoX ) );

end

