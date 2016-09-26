% script to run DAD on new datasets

filename = 'testdata-foreva';
[Y,T,X] = compile_neuraldata([1,5,6,7],20,filename);

M1{1} = 'FA'; 
[Vr,~] = computeV(Y,3,M1);
V = Vr{1};

figure, 
colorData(V,T)
title(filename)