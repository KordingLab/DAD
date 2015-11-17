function C = setinputparams()

C.delT=0.2;
C.winSz=1.1;
C.thresh=0.8;
C.EigRatio=1e-5;
C.winsz=20;
C.lamnum=100;
C.fldnum=5;
C.th1l=1;
C.th1u=inf;
C.th2l=1;
C.th2u=inf;
C.gnum=200;
C.anum= 20 ;
C.pig=linspace(-pi,pi,C.gnum);
C.scg=linspace(0.8, 1.2, C.anum);

end