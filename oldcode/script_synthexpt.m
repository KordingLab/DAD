load DadData
saveName = 'Results-1-10-16(3)';
C = setinputparams();
C.delT=.2;
avec = C.pig;
svec = C.scg;

N = ceil(2.^(7:0.4:11));
LN = length(N);
numTrials = 50;

Rb = cell(LN,100);
Rmod = cell(LN,100);

R2b = zeros(LN,100);
R2mod = zeros(LN,100);

for j=1:numTrials
    for i=1:LN
        Rb{i,j} = runsynthexpt(Xtest,Ttest,Xtrain,avec,svec,5,N(i),'base');
        tmp1 = Rb{i,j}.R2val,
        R2b(i,j) = tmp1;

        Rmod{i,j} = runsynthexpt(Xtest,Ttest,Xtrain,avec,svec,5,N(i),'modbase');
        tmp2 = Rmod{i,j}.R2val,
        R2mod(i,j) = tmp2;
    end
    save(saveName)
    display(['Finished with Iteration ',int2str(j)])
end