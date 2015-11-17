function [YrKL, minVal, KLD, KLS, YLr, YLsc] = minKL(Y,X,C)
YLo2 = Y;
XAll = X;

cosg = cos(C.pig);
sing  = sin(C.pig);

k=ceil(size(XAll,1)^0.3);
dMatX=getDist(XAll,XAll);
sdMatX=sort(dMatX);
rhoX=sdMatX(k,:);
YLr  = cell(2*C.gnum,1);
YLsc = cell(C.anum,1);
KLD = zeros(2*C.gnum,1);
KLS = zeros(C.anum,1);

for p=1:2*C.gnum
    pm = mod(p-1,C.gnum)+1;
    ps = 2*floor((p-1)/C.gnum)-1;
    rm = [ps,0;0,1]*[cosg(pm),-sing(pm);sing(pm),cosg(pm)];
    YLr{p} = YLo2 * rm;
    dMatT=getDist( XAll , YLr{p} );
    [sdMatT,~]=sort(dMatT);
    sdMat=sdMatT;
    rhoY=sdMat(k,:);
    KLD(p)=mean( log( rhoY ./ rhoX ) )+log( C.dSzE / C.dASz );
end

[~, minInd ]   = min( KLD );
YrKLR  = YLr{minInd};


for p=1:C.anum
    YLsc{p}    = C.scg(p)*YrKLR;
    dMatT    = getDist( XAll , YLsc{p} );
    [sdMatT, ~] = sort(dMatT);
    sdMat=sdMatT;
    rhoY=sdMat(k,:);
    KLS(p)=mean( log( rhoY ./ rhoX ) )+log( C.dSzE / C.dASz );
end

[minVal , minInd]   = min( KLS );
YrKL  = YLsc{minInd};
                    
end % end main function