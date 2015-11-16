clear all
delT=0.2;
winSz=1.1;
thresh=0.8;
EigRatio=1e-5;
winsz=20;
lamnum=100;
fldnum=5;


C.gnum=200;
C.anum= 20 ;

C.pig=linspace(-pi,pi,C.gnum);
C.scg=linspace(0.8, 1.2, C.anum);

%close all

%load Chewie_12192013;
%load Chewie_03192015;
%Dtr1= out_struct;

%load Chewie_10032013;
%Dtr2= out_struct;
%load Chewie_10032013;
%Dtr3= out_struct;
load Mihi_small;
Dtr1=out_struct;

load Chewie_07152015;
Dte= out_struct;



tttr1  = ff_trial_table_co(Dtr1);
%tttr2  = ff_trial_table_co(Dtr2);
ttte  =  ff_trial_table_co(Dte);

[Y1   , X1 ,  T1,  N1]  =  getFR(Dtr1,  delT,  tttr1 );
%[Y2   , X2 ,  T2,  N2]  =  getFR(Dtr2,  delT,  tttr2 );
[Y3   , X3 ,  T3,  N3]  =  getFR(Dte,   delT,  ttte );


clear Dtr1
%clear Dtr2
clear Dte


th1lsz=1;
th1usz=1;
th2lsz=1;
th2usz=1;


th1l=1;
th1u=inf;
th2l=1;
th2u=inf;

%%Train and test data
%Ytr=[Y1;Y2];




XN1=normal(X1);
%XN2=normal(X2);
% Xtr=[ XN1; XN2 ];
% Ttr=[ T1; T2 ];
% Ntr=[N1; N2];

Xtr= XN1;
Ttr= T1;
Ntr= N1;



dsz=size(Y3,1);
dsz1=round(dsz/3);

Yte=Y3(dsz1+1:end, :);
Xte=X3(dsz1+1:end, :);
Tte=T3(dsz1+1:end, :);
Nte=N3(dsz1+1:end, :);

dimte=size(Yte,2);


tindte= (  Tte ~=7 & Tte ~= 0  & Tte~=2);
tindtr= (  Ttr ~=7 & Ttr ~= 0  & Ttr~=2 );


Xtr= Xtr(tindtr,:);
Ttr= Ttr(tindtr,:);
Ntr= Ntr(tindtr,:);

Tte=Tte(tindte);
Yte=Yte(tindte,:);
Xte=Xte(tindte,:);
Nte=Nte(tindte,:);





XteN=normal(Xte);

R2KL    = zeros(th1lsz,th1usz,th2lsz,th2usz);
vKL     = zeros(th1lsz,th1usz,th2lsz,th2usz);
YrKLMat = cell(th1lsz,th1usz,th2lsz,th2usz);
idxMat  = cell(th1lsz,th1usz,th2lsz,th2usz);
YLoMat  = cell(th1lsz,th1usz,th2lsz,th2usz);
Wcell   = cell(th1lsz,th1usz,th2lsz,th2usz);
mMat    = cell(th1lsz,th1usz,th2lsz,th2usz);
thMat   = cell(th1lsz,th1usz,th2lsz,th2usz);

c1=0;

C.dASz=size(Xtr,1);

%XAll=normal(Xtr);
XAll=normal(Xtr);

%Xten=normal(Xte);
Xten=normal(Xte);


ko=0;

count_down=th1lsz*th2lsz*th1usz*th2usz;

for a1l=th1l
    c1=c1+1;
    c2=0;
    for a1u=th1u
        
        c2=c2+1;
        c3=0;
        
        for a2l=th2l
            
            
            c3=c3+1;
            c4=0;
            
            for a2u=th2u
                count_down=count_down-1 
                c4=c4+1
                
                
                %%%%%%%%%%%%%%%      Preprocessing      %%%%%%%%%%%%%%%%%%%%
               
                
                
                [ Yter , idx1, idx2] = preprocess( Yte , a1l , a1u , a2l , a2u,winsz);
                Tter = Tte(idx2);
                [CP, SP, LP]= pca(Yter);
               
                if length(idx1)>1 && length(idx2)>1 && min(LP)>EigRatio*max(LP)
                    
                    C.dSz=size(Xtr,1);
                    C.ySz=  size(Yter,2);
                    C.dSzE=size(Yte,1);
                    dszt=size(Yter,1);
                    %%%%%%%%%%%%%%%     Dimensionality reduction   %%%%%%%%%%%%%%
                    
                   
                    my=mean(Yter);
                    myV=ones(length(idx2),1)*my;
                    YterZ=Yter-myV;
                    
                    [lambda,psi,T,stats,F]  = factoran(YterZ,2);
                    Yterc=Yte(:,idx1);
                    mybv=ones( C.dSzE,1)*my;
                    
                    %%%%%%%%%%%%%%%         Normalizing the input    %%%%%%%%%%%%%%
                    
                    %size(YterZ)
                    v1=ones(dszt,1);
                    v1L=ones(C.dSzE,1);
                    Yreg=[Yte(idx2,:),v1];
                    drsz=length(idx1);
                    YteL=[Yte,v1L];     
                    lam=    2*norm(Yreg'*Yreg);
                    What=   pinv(Yreg'*Yreg+ lam*eye(dimte+1))* Yreg'* F;
                    YLoEst= Yreg*What;
                    YLoAll= YteL*What;
                    YLo2=   normal(YLoAll);
   
                    
                    %%%%%%%%%%%             Correcting the rotation and scaling       %%%%%%%%%
                    %[ YrKL , minval , KLD, KLP] = KLmin(YLo2, XAll, C);
                    
                    [YrKL, minVal, KLD, KLS, YLr, YLsc] = minKL(YLo2, XAll, C);
                    
                    sstot = sum( var( XteN ) );
                    ssKL = sum( mean(( XteN-YrKL ).^2) ); %XteN real kinematics
                    R2KL(c1, c2, c3, c4)          =   1-ssKL/sstot;
                    R2KLC= R2KL(c1, c2, c3, c4)
                    vKL(c1, c2, c3, c4)           =   min(KLD);
                    vKLC= vKL(c1, c2, c3, c4) 
                    YrKLMat{ c1,   c2,  c3,  c4}  =   YrKL; %predicted kinematics
                    YLoMat{  c1,   c2,  c3,  c4}  =   YLo2; 
                    idxMat{  c1,   c2,  c3,  c4}  =   idx1;
                    Wcell{   c1,   c2,  c3,  c4}  =   What;
                    mMat{    c1,   c2,  c3,  c4}  =   my;
                    thMat{  c1,   c2,  c3,  c4}   =  [a1l, a1u, a2l, a2u];
                    
      
                else
                   diascardall=[a1l , a1u , a2l , a2u]
                end;
                
                save ResMihiFAAcc23rd C R2KL vKL KLD YLr YrKLMat YLoMat XteN  Xte Xtr  Nte  Ntr  Ttr Tte Yte  idxMat Wcell mMat thMat 
                % Tte index of directions; targ_angs = [pi/2, pi/4, 0, -pi/4, -pi/2, -3*pi/4, pi, 3*pi/4];
            end
        end;
    end;
end;



return;







