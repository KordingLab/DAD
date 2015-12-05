function [What,FVAL,R2,R3] = rotate2KL(Xtrain,Ytest_ext,Winit,numiter)

p_train = prob_grid(normal(Xtrain));
x_sz = 2;

options= optimoptions('fminunc','Algorithm','quasi-newton',...
    'GradObj','off','Display','off', 'MaxFunEvals', 1.5e4);

ftheta= @(theta)evalKLDiv_gridwrot(Winit,theta,Ytest_ext, x_sz, p_train);

theta_hat = zeros(72,1); 
FVAL = zeros(72,1);
for i=1:72
    [theta_hat(i),FVAL(i)] = fminunc(ftheta,i*5, options); 
end

[~,id] = min(FVAL);
R2 = rotmat(theta_hat(id));

fKL= @(W)evalKLDiv_gridwrot(W,theta_hat(id), Ytest_ext, x_sz, p_train);

if nargin>3
    options= optimoptions('fminunc','Algorithm','quasi-newton',...
    'GradObj','off','Display','iter-detailed', 'MaxFunEvals', 1.5e4,...
    'maxIter',numiter);
else
    options= optimoptions('fminunc','Algorithm','quasi-newton',...
    'GradObj','off','Display','iter-detailed', 'MaxFunEvals', 1.5e4,...
    'maxIter',5);
end

[What, FVAL]= fminunc(fKL, Winit, options);

rot2x=1;
if rot2x==1
    % run one more rotation step
    options= optimoptions('fminunc','Algorithm','quasi-newton',...
        'GradObj','off','Display','off', 'MaxFunEvals', 1.5e4);

    ftheta= @(theta)evalKLDiv_gridwrot(What*R2,theta,Ytest_ext, x_sz, p_train);
    theta_hat2 = zeros(72,1); 
    FVAL2 = zeros(72,1);
    for i=1:72
        [theta_hat2(i),FVAL2(i)] = fminunc(ftheta,i*5, options); 
    end

    [~,id] = min(FVAL2);
    R3 = rotmat(theta_hat2(id)); 
end


end