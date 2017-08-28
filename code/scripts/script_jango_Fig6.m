% Script to Generate Figure 6

% using parameters from minKL solution
whichtarg = [2,5,6,8]; % which targets to select reaches from
opts.dimred_method = 'Isomap';
opts.gridsz = 10;
opts.numT = 1;
opts.numD = 3;
opts.numS = 8;
opts.sfac = 2;

% download data
[Ytr,Ttr,Xtr] = compile_jango_neuraldata(whichtarg,opts.numS,opts.numD,'binnedData_0801.mat');
[Yte2,Tte2,Xte2] = compile_jango_neuraldata(whichtarg,opts.numS,opts.numD,'binnedData_0807.mat');
Yte2 = downsamp_nd(Yte2,opts.sfac);
[Yte3,Tte3,Xte3] = compile_jango_neuraldata(whichtarg,opts.numS,opts.numD,'binnedData_0819.mat');
Yte3 = downsamp_nd(Yte3,opts.sfac);
[Yte4,Tte4,Xte4] = compile_jango_neuraldata(whichtarg,opts.numS,opts.numD,'binnedData_0901.mat');
Yte4 = downsamp_nd(Yte4,opts.sfac);

%%
[Xrec2,Vflip2,Vr2] = runDAD3d(Xtr,Yte2,opts);
[Xrec3,Vflip3,Vr3] = runDAD3d(Xtr,Yte3,opts);
[Xrec4,Vflip4,Vr4] = runDAD3d(Xtr,Yte4,opts);

%Hinv = Xrec2(:,1:2)'*pinv(Yte2)';



