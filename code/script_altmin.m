
Y = Ytest;

% 3D model
%Vdir = atan2(Xtest(:,2),Xtest(:,1));
%Vmag = norms(Xtest')';
%Xtest2 = [Xtest, Vmag, log(Vmag).*cos(Vdir), log(Vmag).*sin(Vdir), log(Vmag)]; 

%Xtest2 = [log(Vmag).*cos(Vdir), log(Vmag).*sin(Vdir), log(Vmag)]; Xnew = Xtest2;
%X0 = Xtest2 + randn(size(Xtest2))*10;
%X0 = Xtest;

%Xnew = Xtest + randn(size(Xtest))*0;

% permuted starting point
%permz = randperm(T);
%new = Xtest2(permz,:);

Xnew = Xtest;

id = find(sum(Ytest)<50);
Y=Ytest; Y(:,id)=[];

[T,N] = size(Y);

NumIter = 1;
dev = zeros(N,NumIter);
display = 0;
R2val = zeros(NumIter,1);

for j=1:NumIter
    
    Wcurr = zeros(size(Xnew,2)+1,N);
    for i=1:N
        [Wcurr(:,i),dev(i,j),~] = glmfit(Xnew,Y(:,i),'poisson'); 
    end
    
    if display==1
        close all,
        figure; subplot(1,3,1); colorData2014(Xtest,Ttest); 
        subplot(1,3,2); colorData2014(Xnew(:,1:min(3,size(Xnew,2))),Ttest); 
        title(num2str(evalR2(Xtest,Xnew(:,1:2)),3));
    end

    Xcurr = zeros(T,size(Xnew,2));
    for i=1:T
        Xcurr(i,:) = glmfit(Wcurr(2:end,:)',Y(i,:),'poisson','offset',Wcurr(1,:)','constant','off')'; 
    end
    
    Xnew = Xcurr;
    
    if display==1
        subplot(1,3,3); hold off; colorData2014(Xnew(:,1:min(3,size(Xnew,2))),Ttest); 
        title(num2str(evalR2(Xtest,Xnew(:,1:2)),3));
        pause,
    end
    
    R2val(j) = evalR2(Xtest,Xnew(:,1:2));
    
end

