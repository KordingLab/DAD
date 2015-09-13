function [  Yo , idx1,   idx2, val, th2lm, th2um] = preprocess(Y,th1l,th1u,th2l,th2u,winSzh)



m1=std(Y);

th1lm = th1l*mean(m1);
th1um = th1u*mean(m1);
idx1=find( m1>th1lm  & m1<th1um );
Y=Y(:,idx1);

dsz=size(Y,1);


Yo=[];
idx2=[];

%val=zeros(1,dsz);
%th2lm=zeros(1,dsz);
%th2um=zeros(1,dsz);
%my=mean(Y);
%Y=Y./repmat(my,size(Y,1),1);



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
    %m2=sum(Y(is:ie,:).^2,2);
    
    m2=mean(Y(is:ie,:));
    th2lm(i)=th2l * mean(m2);
    th2um(i)=th2u * mean(m2);
    
    %val(i)=sum(Y(i,:).^2,2);
    val(i)=mean(Y(i,:));
    
    if val(i)>th2lm(i) && val(i)<th2um(i)
        idx2=[ idx2; i];
        Yo=[Yo;Y(i,:)-mean(m2)];
    end;
    
end;

return;



