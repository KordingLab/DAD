function [Yout, idx1, idx2] = preprocess(Y0,th1l,th1u,th2l,th2u,winSzh)
%th1l = lower threshold on columns of Y (neurons), val > th1l*mean 
%th1u = upper threshold on columns of Y (neurons), val < th1u*mean 
%th2l = lower threshold on rows of Y (time points), val > th1l*mean 
%th2u = upper threshold on rows of Y (time points), val < th1u*mean 

m1=std(Y0);
th1lm = th1l*mean(m1);
th1um = th1u*mean(m1);
idx1=find( m1>th1lm  & m1<th1um );
Y=Y0(:,idx1);

dsz=size(Y,1);

Yout=[];
idx2=[];

for i=1:dsz
    
    
    is = i-winSzh+1;
    ie = i+winSzh;
    
    
    if i<winSzh
        is=1;
        ie=2*winSzh;
    end;
    
    
    if i>dsz-winSzh
        is=dsz-2*winSzh+1;
        ie=dsz;
    end;    
    m2=mean(Y(is:ie,:));
    th2lm(i)=th2l * mean(m2);
    th2um(i)=th2u * mean(m2);

    val(i)=mean(Y(i,:));
    
    if val(i)>th2lm(i) && val(i)<th2um(i)
        idx2=[ idx2; i];
        Yout=[Yout;Y(i,:)-mean(m2)];
    end
    
end

end % end main function


