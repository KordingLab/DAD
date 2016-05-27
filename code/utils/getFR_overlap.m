function [Y, X, T, N]  =  getFR_overlap( D, delT, tt, TO)

ne = D.units;
v   = D.vel;
nesz=length(ne);
ttsz=size(tt,1);

Y=[];
X=[];
T=[];
N=[];


for j=1:ttsz(1)
    
    minT  = tt(j, 10);
    maxT  = tt(j,13);
    grids= minT:(delT-TO):(maxT-delT);
    gride= (minT+delT):(delT-TO):maxT;
    binNum= length(grids);
    
    if binNum>0
        YP=zeros(binNum , nesz);
        XP=zeros(binNum,2);
        TP=zeros(binNum,1);
        width=gride(1) - grids(1);
        
        for k = 1 : binNum
            bi  =  (  v(:,1) >= grids(k)  &  v(:,1) <= gride(k)  );
            XP( k , : )   =  mean( v(  bi , 2:3 ),1 );
            TP(k,1)=tt(j,2);
        end;
        
        sptot=0;
        
        for  i=1:nesz
            for k=1:binNum
                spsum = sum( ne(i).ts >= grids(k) &  ne(i).ts  <= gride(k)  );
                YP(k, i) = spsum / width;
                sptot  = sptot  + spsum;
            end;
        end;
        
        
        Y=[Y; YP];
        X=[X; XP];
        T=[T;TP];
        N=[N;1;zeros(max(size(TP,1)-1,0),1)];
        
        
    end;
end;

return;

