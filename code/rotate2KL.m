function [What,Results] = rotate2KL(Xtrain,Ytest_ext,Winit,numiter)

numouter = 2;
x_sz = 2;
gsz = 72;

optionsTheta= optimoptions('fminunc','Algorithm','quasi-newton',...
    'GradObj','off','Display','off', 'MaxFunEvals', 1.5e4);

if nargin>3
        optionsKL= optimoptions('fminunc','Algorithm','quasi-newton',...
        'GradObj','off','Display','iter-detailed', 'MaxFunEvals', 1.5e4,...
        'maxIter',numiter);
else
        optionsKL= optimoptions('fminunc','Algorithm','quasi-newton',...
        'GradObj','off','Display','iter-detailed', 'MaxFunEvals', 1.5e4,...
        'maxIter',5);
end
    

%%%%%%%%%%%%
% compute probability grid (heatmat) for Xtrain
p_train = prob_grid(normal(Xtrain));

Wcurr = Winit;
for iout = 1:numouter % (outer) iteration 
    
    ftheta= @(theta)evalKLDiv_gridwrot(Wcurr,theta,Ytest_ext, x_sz, p_train);

    theta_hat = zeros(gsz,1); 
    FVAL = zeros(gsz,1);
    for i=1:gsz
        [theta_hat(i),FVAL(i)] = fminunc(ftheta,i*5, optionsTheta); 
    end

    [~,id] = min(FVAL);
    R = rotmat(theta_hat(id));

    fKL= @(W)evalKLDiv_gridwrot(W,theta_hat(id), Ytest_ext, x_sz, p_train);

    [What, FVAL]= fminunc(fKL, Wcurr, optionsKL);
    
    
    Results.FVAL{iout} = FVAL;
    Results.What{iout} = What; 
    Results.R{iout} = R;
    
    Wcurr = What*R;
    
end


end