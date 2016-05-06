% script 3D alignment (run DAD on real datasets)

%% (1) within subjects (iteration over different partitions of train/test sets)

randseed = randi(100,1);
rng(randseed)

whichdirs = input('Which pattern ? Enter 1 if (012) and 2 if (027): ');
if whichdirs==1
    removedir = [0, 1, 2];
    Ntot = 1027;
else
    removedir = [0, 2, 7];
    Ntot = 1069;
end

numA = 180; %every 2 deg
Ts=.20; 

percent_samp = 0.15;
gridsz = 7;

numsol = 5;
numIter = input('Number of iterations? ');
M1{1} = 'FA'; 

addname = input('Enter string to append to end of file name: ');

if percent_samp==0.15
    numsteps = 9;
    foffset = 0.2;
    fstep = 0.1;
elseif percent_samp==0.3
    numsteps = 9;
    foffset = 0.2;
    fstep = 0.1;
end

percent_test = linspace(foffset,foffset+numsteps*fstep,numsteps+1);

%% prepare data

Data0 = prepare_superviseddata(Ts,'chewie1','mihi',[]);
Data = prepare_superviseddata(Ts,'mihi','mihi',[],0);
[~,~,~,XtrC,~,~,~,~] = removedirdata(Data0,removedir);
[Xtest,Ytest,Ttest,Xtrain,Ytrain,Ttrain,~,Ntrain] = removedirdata(Data,removedir);
clear Data Data0

% initialize variables
R2 = cell(numIter,1);
R2MC = cell(numIter,1);
 
for nn = 1:numIter % random train/test split

        [Xtr,Ytr,Ttr,Xte0,Yte0,Tte0,trainid,testid] = splitdataset(Xtrain,Ytrain,Ttrain,Ntrain,percent_samp); 
        numte = size(Yte0,1);
        permzte = randperm(numte);
           
        R2X = zeros(3+numsol,numsteps);
        R2sup = zeros(1,numsteps);
        R2ls = zeros(1,numsteps);
        R2Ave = zeros(1,numsteps);
        
        R2XMC = zeros(3+numsol,numsteps);
        R2supMC = zeros(1,numsteps);
        R2lsMC = zeros(1,numsteps);
        R2AveMC = zeros(1,numsteps);
        Nsamp = zeros(1,numsteps);
        
        for mm = 1:numsteps % loop over amount of test data
            
            Ns = round(percent_test(mm)*(1-percent_samp)*Ntot);
            numtest = ceil((foffset + fstep*mm)*numte);
            Xte = Xte0(permzte(1:numtest),:);
            Yte = Yte0(permzte(1:numtest),:);
            Tte = Tte0(permzte(1:numtest),:);

            %%%% supervised & least-squares
            fldnum=10; lamnum=500;
            [Wsup, ~, ~, ~]= crossVaL(Ytr, Xtr, Yte, lamnum, fldnum);
            Xsup = [Yte,ones(size(Yte,1),1)]*Wsup;
            r2sup = evalR2(Xte,Xsup);     
            % least squares error (best 2 dim projection)
            warning off, Wls = (Yte\Xte); r2ls = evalR2(Xte,Yte*Wls); 

            %% run DAD (3D to 2D)
            Res = runDAD(Yte,Xtr,4,Tte,Xte);
            Xave = normal((Res.Xrec+Xsup)/2);
            r2ave = evalR2(Xte,Xave); 
            
            R2Ave(mm) = r2ave;
            R2X(mm) = Res.R2;
            R2sup(mm) = r2sup; 
            R2ls(mm) = r2ls;
            Nsamp(mm) = Ns;
            
            %%% now for augmented training
            ResMC = runDAD(Yte,[Xtr; XtrC],gridsz,Tte,Xte);
            Xave = normal((Res.Xrec+Xsup)/2);
            r2ave = evalR2(Xte,Xave); 
            
            R2AveMC(mm) = r2ave;
            R2XMC(mm) = ResMC.R2;
            R2supMC(mm) = r2sup; 
            R2lsMC(mm) = r2ls;

            display(['Supervised decoder, R2 = ', num2str(r2sup,3)])    
            display(['Least-squares Projection, R2 = ', num2str(r2ls,3)])
            display(['Num test = ', int2str(numtest), ' Iter # ', int2str(nn)])
            display('***~~~~~~++++~+~+~+~+~++~+~+~***')  

        end
        
        % save 
        R2tot = [R2X;  R2Ave; R2sup; R2ls];
        R2{nn} = R2tot;
        
        R2tot = [R2XMC; R2AveMC; R2supMC; R2lsMC];
        R2MC{nn} = R2tot;
               
end

R2order{1} = 'Xfinal';
R2order{2} = 'Xicp';
R2order{3} = 'Vfa';
R2order{4} = 'Xflip1';
R2order{5} = 'Xflip2';
R2order{6} = 'Xflip3';
R2order{7} = 'Xflip4';
R2order{8} = 'Xflip5';
R2order{9} = 'Xave';
R2order{10} = 'Xsup';
R2order{11} = 'Xls';

% save these variables
percent_test = foffset + fstep*[1:numsteps];
percent_train = percent_samp;

removestr = ['-removedir-',int2str(removedir(1)),...
                int2str(removedir(2)),int2str(removedir(3))];

save(['Results-',date,'-psamp-', int2str(100*percent_samp),'-numIter-',...
    int2str(numIter), removestr,'-', addname],'R2','R2MC','R2order',...
    'percent_train','percent_test','removedir','numsol','randseed','Nsamp')

%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%




