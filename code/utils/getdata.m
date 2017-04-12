function [Y1, X1, T1, N1] =  getdata(whichmonkey,delT)

if strcmp(whichmonkey,'mihi')
    load Mihi_small
    
elseif strcmp(whichmonkey,'chewie1')
     load('Chewie_10032013.mat')
        
elseif strcmp(whichmonkey,'chewie2')
    load('Chewie_12192013.mat')

else
    display('Specify which dataset you wish me to prepare!')
end

Dtr1=out_struct;
tttr1  = ff_trial_table_co(Dtr1);
[Y1   , X1 ,  T1,  N1]  =  getFR_overlap(Dtr1,  delT,  tttr1 , delT/2);

end