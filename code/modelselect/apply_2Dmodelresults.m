function Results = apply_2Dmodelresults(Results,model_select,filenm) 

% script to run model on new data jango - test model select
monkey = Results.monkey;
removedir = Results.removedir;
whichtarg = setdiff(0:7,removedir);
Xtr = Results.Xtr;

%%
load(filenm)

if model_select==1
    numSfinal = Results.numS_minKL;
    numDfinal = Results.numD_minKL;
    sfacfinal = Results.sfac_minKL;
    drmethodfinal = Results.drmethod_minKL;
elseif model_select==2
    numSfinal = Results.numS_maxR2;
    numDfinal = Results.numD_maxR2;
    sfacfinal = Results.sfac_maxR2;
    drmethodfinal = Results.drmethod_maxR2;
elseif model_select==3
    numSfinal = Results.numS_smooth;
    numDfinal = Results.numD_smooth;
    sfacfinal = Results.sfac_smooth;
    drmethodfinal = Results.drmethod_smooth;
else
    numSfinal = Results.numS_maxTarg;
    numDfinal = Results.numD_maxTarg;
    sfacfinal = Results.sfac_maxTarg;
    drmethodfinal = Results.drmethod_maxTarg;
end

%%
if strcmp(monkey,'jango')
    [Yte{1},Tte{1},Xte{1}] = compile_jango_neuraldata(whichtarg,numDfinal,numSfinal,'~/Documents/repos/DAD/data/Jango/binnedData_0801.mat');
    [Yte{2},Tte{2},Xte{2}] = compile_jango_neuraldata(whichtarg,numDfinal,numSfinal,'~/Documents/repos/DAD/data/Jango/binnedData_0807.mat');
    [Yte{3},Tte{3},Xte{3}] = compile_jango_neuraldata(whichtarg,numDfinal,numSfinal,'~/Documents/repos/DAD/data/Jango/binnedData_0819.mat');
    [Yte{4},Tte{4},Xte{4}] = compile_jango_neuraldata(whichtarg,numDfinal,numSfinal,'~/Documents/repos/DAD/data/Jango/binnedData_0901.mat');
    
    Vout=cell(4,1);
    for i=1:4
        Yr = smooth_neuraldata(Yte{i},sfacfinal);
        [Vout{i}, ~] = runDAD2d(Yr,Xtr,drmethodfinal);
    end
    
elseif strcmp(monkey,'chewie')
    load('~/Documents/repos/DAD/data/Chewie/Chewie_CO_VR_2016_10_06.mat')
    [Yte{1},~,Tte{1},~,Xte{1},~,~,~] = compile_reaching_data(trial_data,numDfinal,numSfinal,'go',whichtarg,5);
    
    load('~/Documents/repos/DAD/data/Chewie/Chewie_CO_FF_2016_10_07.mat')
    [Yte{2},~,Tte{2},~,Xte{2},~,~,~] = compile_reaching_data(trial_data,numDfinal,numSfinal,'go',whichtarg,5);
    
    load('~/Documents/repos/DAD/data/Chewie/Chewie_CO_FF_2016_10_11.mat')
    [Yte{3},~,Tte{3},~,Xte{3},~,~,~] = compile_reaching_data(trial_data,numDfinal,numSfinal,'go',whichtarg,5);
    
    Vout=cell(3,1);
    for i=1:3
        Yr = smooth_neuraldata(Yte{i},sfacfinal);
        [Vout{i}, ~] = runDAD2d(Yr,Xtr,drmethodfinal);
    end
    
else strcmp(monkey,'mihi2D')
    
    Data = prepare_superviseddata(0.05,'chewie1','mihi',[],0); % 50 ms bins (same as jango)
    [Xte{1},Yte{1},Tte{1},~,~,~,~,~] = removedirdata(Data,removedir,numDfinal,numSfinal);
    Yr = smooth_neuraldata(Yte{1},sfacfinal);
    [Vout{1}, ~] = runDAD2d(Yr,Xtr,drmethodfinal);
    
end
    
Results.Vout = Vout;
Results.Yte = Yte;
Results.Tte = Tte;
Results.Xte = Xte;
    

end % end function




