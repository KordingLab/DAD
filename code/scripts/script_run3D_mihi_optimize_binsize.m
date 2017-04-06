
% script to optimize bin size.
removedir = [0, 1,3,6];
numS = 15;
numD = 0;
M1{1} = 'FA'; 
for i=1:6
    Data = prepare_superviseddata(0.05*i,'chewie1','mihi',[],0);
    [Xte,Yte,Tte,Xtr,Ytr,Ttr,Nte,Ntr] = removedirdata(Data,removedir,numS,numD);
    Yte2 = downsamp_nd(Yte,10);
    [XrecM{i},VflipM{i},Vr{i},minKLM{i},meanresM(i)] = runDAD3d(normal(mapX3D(Xtr)),Yte2,'FA');
    R2_alldata(i) = evalR2(Xte(:,1:2),XrecM{i});
    display(['R2 = ', num2str(R2_alldata(i),3), ' Ts = ', num2str(0.05*i,2)])
    Xtest{i} = Xte;
    Ttest{i} = Tte; 
end

% %% compute R2 values
% R2_alldata = zeros(5,1);
% for i=1:6, 
%     R2_alldata(i) = evalR2(XteM(:,1:2),XrecM{i}); 
% end

% KL_alldata = zeros(5,5);
% for i=1:5, 
%     KL_alldata(1,i) =  min(minKLM{i});
%     KL_alldata(2,i) =  min(minKLC{i});
%     KL_alldata(3,i) =  min(minKLJ2{i});
%     KL_alldata(4,i) =  min(minKLJ3{i});
%     KL_alldata(5,i) =  min(minKLJ4{i});
% end
% 
% VarExp_alldata(1,:) =  meanresM;
% VarExp_alldata(2,:) =  meanresC;
% VarExp_alldata(3,:) =  meanresJ2;
% VarExp_alldata(4,:) =  meanresJ3;
% VarExp_alldata(5,:) =  meanresJ4;
% 
% 
% figure, 



