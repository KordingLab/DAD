function [What,Results] = rotate2KL(Xtrain,Ytest_ext,Winit,numiter,numouter,bsz)

if nargin<5
    numouter = 1;
end

x_sz = 2;
gsz = 36;

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
p_train = prob_grid(normal(Xtrain),bsz);

Wcurr = Winit;
for iout = 1:numouter % (outer) iteration 
    
    ps = [-1,1];
    FVAL = zeros(gsz,2);
    for j=1:2
        ftheta= @(theta)evalKLDiv_gridwrot(Wcurr,theta,ps(j),Ytest_ext,x_sz,p_train,bsz);
        theta_hat = zeros(gsz,1); 
        for i=1:gsz
            [theta_hat(i),FVAL(i,j)] = fminunc(ftheta,i*10, optionsTheta); 
        end
        j,
    end
    
    theta2 = [theta_hat, theta_hat];
    [~,id] = min(FVAL(:));
    [~,ci] = ind2sub(size(FVAL),id);
    
    ps2 = ps(ci);
    R = rotmat(theta2(id));
    
    fKL= @(W)evalKLDiv_gridwrot(W,theta2(id),ps2,Ytest_ext, x_sz, p_train,bsz);

    [What, FVAL]= fminunc(fKL, Wcurr, optionsKL);
    
    
    Results.FVAL{iout} = FVAL;
    Results.What{iout} = What; 
    Results.R{iout} = R;
    Results.ps{iout} = ps2;
    
    Wcurr = What*R;
    
end


end % end function