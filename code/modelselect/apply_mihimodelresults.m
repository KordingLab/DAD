function Results = apply_mihimodelresults(Results,model_select,modelfilenm) 

%removedir = Results.removedir;
%check2D = 1; % check 2D projction as well, select dim with smallest KL
%numT = 1; % if 1, no translational search (in addition to rotatation)
%numDfinal = 0;
%numSfinal = 40;

%if nargin<4
%    numang_steps=8; % resolution of 3D search (increase to sample more)
%end

%% %%  THIS ISNT PRODUCING SAME RESULTS AS MAIN SCRIPT...
load(modelfilenm)

% if model_select==1
%     binszfinal = Results.binsz_minKL;
%     sfacfinal = Results.sfac_minKL;
%     drmethodfinal = Results.drmethod_minKL;
% elseif model_select==2
%     binszfinal = Results.binsz_maxR2;
%     sfacfinal = Results.sfac_maxR2;
%     drmethodfinal = Results.drmethod_maxR2;
% elseif model_select==3
%     binszfinal = Results.binsz_smooth;
%     sfacfinal = Results.sfac_smooth;
%     drmethodfinal = Results.drmethod_smooth;
% else
%     binszfinal = Results.binsz_maxTarg;
%     sfacfinal = Results.sfac_maxTarg;
%     drmethodfinal = Results.drmethod_maxTarg;
% end


%%%%%% so a look up for now...

%Data = prepare_superviseddata(binszfinal,'chewie1','mihi',[],0);
%[Xte0,Yte0,Tte0,~,~,~,~,~] = removedirdata(Data,removedir,numDfinal,numSfinal);
%Yte2 = downsamp_nd(Yte0,sfacfinal); % temporal smoothing
%Yr = remove_constcols(Yte2);

%mtmp{1} = drmethodfinal;
%[V,~,~] = computeV(Yr,3,mtmp);
%Vcurr = V{1}; 
%Xn = normal(mapX3D(Results.Xtr));
%[Vout{1},~,~,yKL,minKL3D] = DAD_3Dsearch(Xn,Vcurr,numang_steps,numT,check2D);
 
%Results.minKL3D = minKL3D;
%Results.yKL = yKL;
%Results.Vout = Vout;
%Results.Yte{1} = Yte0;
%Results.Tte{1} = Tte0;
%Results.Xte{1} = Xte0;

%%%%% there is a bug, for now, take Vout from original parameter run.
%%%%% (Results)


if model_select==1 %% min KL
    Results.Yte{1} = Results.Yr_all{Results.coords_minKL(1),Results.coords_minKL(2),1,10};
    Results.Xte{1} = Results.Xte_minKL;
    Results.Tte{1} = Results.Tte_minKL;
    Results.Vout{1} = Results.Xrec_all{Results.coords_minKL};
    
elseif model_select==2 %% maxR2
    Results.Yte{1} = Results.Yr_all{Results.coords_maxR2(1),Results.coords_maxR2(2),1,10};
    Results.Xte{1} = Results.Xte_maxR2;
    Results.Tte{1} = Results.Tte_maxR2;
    Results.Vout{1} = Results.Xrec_all{Results.coords_maxR2};
    
elseif model_select==3 %% smooth
    Results.Yte{1} = Results.Yr_all{Results.coords_smooth(1),Results.coords_smooth(2),1,10};
    Results.Xte{1} = Results.Xte_smooth;
    Results.Tte{1} = Results.Tte_smooth;
    Results.Vout{1} = Results.Xrec_all{Results.coords_smooth};
    
elseif model_select==4 %% maxTarg
    Results.Yte{1} = Results.Yr_all{Results.coords_maxTarg(1),Results.coords_maxTarg(2),1,10};
    Results.Xte{1} = Results.Xte_maxTarg;
    Results.Tte{1} = Results.Tte_maxTarg;
    Results.Vout{1} = Results.Xrec_all{Results.coords_maxTarg};
end


end % end function




