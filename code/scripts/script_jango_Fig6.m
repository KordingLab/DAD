% Script to Generate Figure 6

% using parameters from maxR2 solution (on Day 1)
% load('optimal_parameters_jango_optimize_D1.mat')

whichtarg = [2,5,6,8]; % which targets to select reaches from
opts.dimred_method = 'Isomap';
opts.gridsz = 10;
opts.numT = 1;
opts.numD = 1;
opts.numS = 10;
opts.sfac = 4;
opts.check2D = 1;

%%
% download data
[Yte1,Tte1,Xte1] = compile_jango_neuraldata(whichtarg,opts.numS,opts.numD,'binnedData_0801.mat');
Yte1 = downsamp_nd(Yte1,opts.sfac);
[Yte2,Tte2,Xte2] = compile_jango_neuraldata(whichtarg,opts.numS,opts.numD,'binnedData_0807.mat');
Yte2 = downsamp_nd(Yte2,opts.sfac);
[Yte3,Tte3,Xte3] = compile_jango_neuraldata(whichtarg,opts.numS,opts.numD,'binnedData_0819.mat');
Yte3 = downsamp_nd(Yte3,opts.sfac);
[Yte4,Tte4,Xte4] = compile_jango_neuraldata(whichtarg,opts.numS,opts.numD,'binnedData_0901.mat');
Yte4 = downsamp_nd(Yte4,opts.sfac);

%%
[Vout11] = runDAD2d(Yte1,Xte1,opts.dimred_method);
[Vout12] = runDAD2d(Yte2,Xte1,opts.dimred_method);
[Vout13] = runDAD2d(Yte3,Xte1,opts.dimred_method);
[Vout14] = runDAD2d(Yte4,Xte1,opts.dimred_method);

[Vout21] = runDAD2d(Yte1,Xte2,opts.dimred_method);
[Vout22] = runDAD2d(Yte2,Xte2,opts.dimred_method);
[Vout23] = runDAD2d(Yte3,Xte2,opts.dimred_method);
[Vout24] = runDAD2d(Yte4,Xte2,opts.dimred_method);

[Vout31] = runDAD2d(Yte1,Xte3,opts.dimred_method);
[Vout32] = runDAD2d(Yte2,Xte3,opts.dimred_method);
[Vout33] = runDAD2d(Yte3,Xte3,opts.dimred_method);
[Vout34] = runDAD2d(Yte4,Xte3,opts.dimred_method);

[Vout41] = runDAD2d(Yte1,Xte4,opts.dimred_method);
[Vout42] = runDAD2d(Yte2,Xte4,opts.dimred_method);
[Vout43] = runDAD2d(Yte3,Xte4,opts.dimred_method);
[Vout44] = runDAD2d(Yte4,Xte4,opts.dimred_method);

%%
figure,
subplot(4,4,1), colorData(Vout11,Tte1), title(num2str(evalR2(Vout11,Xte1(:,1:2)),3))
subplot(4,4,2), colorData(Vout12,Tte2), title(num2str(evalR2(Vout12,Xte2(:,1:2)),3))
subplot(4,4,3), colorData(Vout13,Tte3), title(num2str(evalR2(Vout13,Xte3(:,1:2)),3))
subplot(4,4,4), colorData(Vout14,Tte4), title(num2str(evalR2(Vout14,Xte4(:,1:2)),3))

subplot(4,4,5), colorData(Vout21,Tte1), title(num2str(evalR2(Vout21,Xte1(:,1:2)),3))
subplot(4,4,6), colorData(Vout22,Tte2), title(num2str(evalR2(Vout22,Xte2(:,1:2)),3))
subplot(4,4,7), colorData(Vout23,Tte3), title(num2str(evalR2(Vout23,Xte3(:,1:2)),3))
subplot(4,4,8), colorData(Vout24,Tte4), title(num2str(evalR2(Vout24,Xte4(:,1:2)),3))

subplot(4,4,9), colorData(Vout31,Tte1), title(num2str(evalR2(Vout31,Xte1(:,1:2)),3))
subplot(4,4,10), colorData(Vout32,Tte2), title(num2str(evalR2(Vout32,Xte2(:,1:2)),3))
subplot(4,4,11), colorData(Vout33,Tte3), title(num2str(evalR2(Vout33,Xte3(:,1:2)),3))
subplot(4,4,12), colorData(Vout34,Tte4), title(num2str(evalR2(Vout34,Xte4(:,1:2)),3))

subplot(4,4,13), colorData(Vout41,Tte1), title(num2str(evalR2(Vout41,Xte1(:,1:2)),3))
subplot(4,4,14), colorData(Vout42,Tte2), title(num2str(evalR2(Vout42,Xte2(:,1:2)),3))
subplot(4,4,15), colorData(Vout43,Tte3), title(num2str(evalR2(Vout43,Xte3(:,1:2)),3))
subplot(4,4,16), colorData(Vout44,Tte4), title(num2str(evalR2(Vout44,Xte4(:,1:2)),3))

%[Xrec2,Vflip2,Vr2] = runDAD3d(Xtr,Yte2,opts);
%[Xrec3,Vflip3,Vr3] = runDAD3d(Xtr,Yte3,opts);
%[Xrec4,Vflip4,Vr4] = runDAD3d(Xtr,Yte4,opts);

%Hinv = Xrec2(:,1:2)'*pinv(Yte2)';



