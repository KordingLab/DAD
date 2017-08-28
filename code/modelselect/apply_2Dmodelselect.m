function Results = apply_2Dmodelselect(Results,model_select) 

% script to run model on new data jango - test model select
removedir = [0,1,2,6];
whichtarg = setdiff(0:7,removedir);

Xtr = Results.Xtr;
Ttr = Results.Ttr;

%%

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

if strcmp(Results.monkey,'jango')
    [Yte1,Tte1,Xte1] = compile_jango_neuraldata(whichtarg,numSfinal,numDfinal,'~/Documents/GitHub/DAD/data/data/Jango/binnedData_0801.mat');
    [Yte2,Tte2,Xte2] = compile_jango_neuraldata(whichtarg,numSfinal,numDfinal,'~/Documents/GitHub/DAD/data/data/Jango/binnedData_0807.mat');
    [Yte3,Tte3,Xte3] = compile_jango_neuraldata(whichtarg,numSfinal,numDfinal,'~/Documents/GitHub/DAD/data/data/Jango/binnedData_0819.mat');
    [Yte4,Tte4,Xte4] = compile_jango_neuraldata(whichtarg,numSfinal,numDfinal,'~/Documents/GitHub/DAD/data/data/Jango/binnedData_0901.mat');
    
    [Vout1, ~] = runDAD2d( downsamp_nd(Yte1,sfacfinal),Xtr,drmethodfinal);
    [Vout2, ~] = runDAD2d( downsamp_nd(Yte2,sfacfinal),Xtr,drmethodfinal);
    [Vout3, ~] = runDAD2d( downsamp_nd(Yte3,sfacfinal),Xtr,drmethodfinal);
    [Vout4, ~] = runDAD2d( downsamp_nd(Yte4,sfacfinal),Xtr,drmethodfinal);
    
    Results.Vout1 = Vout1;
    Results.Vout2 = Vout2;
    Results.Vout3 = Vout3;
    Results.Vout4 = Vout4;
    
    Results.Yte4 = Yte4;
    Results.Yte3 = Yte3;
    Results.Yte2 = Yte2;
    Results.Yte1 = Yte1;
    
    Results.Tte4 = Tte4;
    Results.Tte3 = Tte3;
    Results.Tte2 = Tte2;
    Results.Tte1 = Tte1;

    Results.Xte4 = Xte4;
    Results.Xte3 = Xte3;
    Results.Xte2 = Xte2;
    Results.Xte1 = Xte1;

else
    load('~/Documents/repos/DAD/data/Chewie/Chewie_CO_VR_2016_10_06.mat')
    [Yte1,~,Tte1,~,Xte1,~,~,~] = compile_reaching_data(trial_data,numDfinal,numSfinal,'go',removedir);
    
    load('~/Documents/repos/DAD/data/Chewie/Chewie_CO_FF_2016_10_07.mat')
    [Yte2,~,Tte2,~,Xte2,~,~,~] = compile_reaching_data(trial_data,numDfinal,numSfinal,'go',removedir);
    
    load('~/Documents/repos/DAD/data/Chewie/Chewie_CO_FF_2016_10_11.mat')
    [Yte3,~,Tte3,~,Xte3,~,~,~] = compile_reaching_data(trial_data,numDfinal,numSfinal,'go',removedir);
    
    [Vout1, ~] = runDAD2d(Yte1,Xtr,drmethodfinal,sfacfinal);
    [Vout2, ~] = runDAD2d(Yte2,Xtr,drmethodfinal,sfacfinal);
    [Vout3, ~] = runDAD2d(Yte3,Xtr,drmethodfinal,sfacfinal);
    
    Results.Vout1 = Vout1;
    Results.Vout2 = Vout2;
    Results.Vout3 = Vout3;
    
    Results.Yte3 = Yte3;
    Results.Yte2 = Yte2;
    Results.Yte1 = Yte1;
    
    Results.Tte3 = Tte3;
    Results.Tte2 = Tte2;
    Results.Tte1 = Tte1;

    Results.Xte3 = Xte3;
    Results.Xte2 = Xte2;
    Results.Xte1 = Xte1;

end



end



%%

%script_visualize_jango_acrossdays

% figure(10), 
% 
%     subplot(4,5,5*(whichtrain-1)+1), colorData(Xtr,Ttr), title(['Training Data (D',int2str(whichtrain),')'])
%     subplot(4,5,5*(whichtrain-1)+2), colorData(Vout1,Tte1), title('Alignment (D1)')
%     subplot(4,5,5*(whichtrain-1)+3), colorData(Vout2,Tte2), title('Alignment (D2)')
%     subplot(4,5,5*(whichtrain-1)+4), colorData(Vout3,Tte3), title('Alignment (D3)')
%     subplot(4,5,5*(whichtrain-1)+5), colorData(Vout4,Tte4), title('Alignment (D4)')

