function [Xcurr,Wcurr,FVAL] = solvesubp(Y,W0,X0,mode,model)
% Supervised Decoder
% [Xcurr,Wcurr,FVAL] = solvesubp(Y,randn(600,2)*0.05,Xtest,1);
% min(W,X) exp(X - Y*W)
if nargin<5
    model = 'linear';
end

[T,N] = size(Y);

% solve for W
if mode==1
   % fix X and solve for W (Nx2)
   % min(Y = WX) [ (NxT)*(Tx2) - Nx2 ]
    if strcmp(model,'linear')
        fx = @(W)evallinearmodel(X0,Y,W);
        options = optimoptions('fminunc','Algorithm','quasi-newton',...
                               'GradObj','off');
        [Wcurr,FVAL] = fminunc(fx,W0,options);    
        Xcurr = X0;
    elseif strcmp(model,'exp-baseline')
        % Y ~ Poiss(exp(WX))
        Wcurr = zeros(3,N);
        for i=1:N
            Wcurr(:,i) = glmfit(X0,Y(:,i),'poisson'); 
        end
        FVAL = 0;
        Xcurr = X0;
    end

% solve for X (decoding model)
elseif mode==2
   % fix W and solve for X
   % min(Y - WX) [ Tx2 - (TxN)*(N*2) ]
    if strcmp(model,'linear')
        fx = @(X)evallinearmodel(X,Y,W0); 
    % Y ~ Poiss(exp(WX))    
    elseif strcmp(model,'exp-baseline')
%         Xcurr = zeros(T,2);
%         for i=1:T
%             fx = @(x)decodefun(x,Y(i,:)',W0);
%             options = optimoptions('fminunc','Algorithm','quasi-newton',...
%                                    'GradObj','off');
%             [Xcurr(i,:),FVAL] = fminunc(fx,X0(i,:),options);    
%         end

        Xcurr = zeros(3,T);
        for i=1:T
            Xcurr(:,i) = glmfit(W0(2:3,:)',Y(i,:),'poisson','offset',W0(1,:)'); 
        end
        FVAL = 0;
        Xcurr = X0;
        Wcurr = W0;
   
    end
end
end % end main function

function fx = evallinearmodel(X,Y,W)

tmp = Y*W;
fx = norm(tmp(:) - X(:));

end


function fx = evalWerr(Y,W,magV,theta_dir)

out = fwdneuronmodel(W(:,1),W(:,2),magV,theta_dir)';
fx = norm(Y(:) - out(:));

end


function fx = decodefun(x,y,W)

x2 = [x, 1];
fx = y.*(W'*x2') - exp(W'*x2');
        
end

