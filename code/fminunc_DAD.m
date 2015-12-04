function [What, Ynew, FVAL, R2VAL, idremove] = fminunc_DAD(Ytest,Xtrain,W0,k,Xtest,optmethod)
% Usage of fmincon
%  min F(X)  subject to:  A*X  <= B, Aeq*X  = Beq (linear constraints)
%      X                  C(X) <= 0, Ceq(X) = 0   (nonlinear constraints)
%                         LB <= X <= UB           (bounds)
% X = fmincon(FUN,X0,A,B,Aeq,Beq,LB,UB,NONLCON,OPTIONS)

if nargin<6
    optmethod = 'fminunc';
end
    
LB = -0.1; 
UB = 0.1;

Y0 = [Ytest,ones(size(Ytest,1),1)];
    

% remove rows of W (neurons) that have ~small weights
idremove = find(sum(abs(W0'))<1e-5); 
W2 = W0; W2(idremove,:)=[];
Y2 = Y0; Y2(:,idremove)=[];

% add random samples
numsamp = 100;
S1 = randn(numsamp,2);

dMatX=getDist([Xtrain; S1],Xtrain);
sdMatX=sort(dMatX);
rhoX=sdMatX(k,:);
    
% add random samples
fKL = @(W)evalKLDiv(W,Xtrain,Y2,k,rhoX,S1);

if strcmp(optmethod,'fminunc')
% set options for optimization alg
options = optimoptions('fminunc','Algorithm','quasi-newton',...
    'MaxIter',2000,'MaxFunEvals',80000,'GradObj','off',...
    'Display','iter-detailed','TolX',1e-6);
    [What,FVAL] = fminunc(fKL,W2,options);
elseif strcmp(optmethod,'fmincon')
    options = optimoptions('fmincon','MaxIter',2000,...
        'MaxFunEvals',80000,'GradObj','off','Display',...
        'iter-detailed','TolX',1e-6);
        Ntmp = size(W2,1);
     A = []; B = []; Aeq = (1/Ntmp)*ones(2,Ntmp); Beq = [0,0];
    [What,FVAL] = fmincon(fKL,W2,A,B,Aeq,Beq,LB*ones(size(W2)),UB*ones(size(W2)),[],options);
end

Ynew = Y0(:,setdiff(1:size(Y0,2),idremove));
Xrec = Ynew*What;

if isempty(Xtest)
    R2VAL = 0;
else
    R2VAL = evalR2(Xrec,Xtest);
end

end

function y = vecnorm(x)
y = sum(x.^2);
end
