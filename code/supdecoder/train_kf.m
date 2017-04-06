function [A, C, Q, R] = train_kf(X,Y)
%%function to generate kalman filter parameters A, C, Q, R from states X
%%and observation Y. X and Y can be cell arrays with each cell containing
%%data for a single reach, where the rows are the timepoints

if(iscell(X))
    nreaches = length(X);
    X_cont = cat(1,X{:});
    Y_cont = cat(1,Y{:});
    X_old = zeros(size(X_cont,1)-nreaches,size(X_cont,2));
    X_new = X_old;
    j=1;
    for i = 1:length(X)

        X_old(j:(j+size(X{i},1)-2),:) =X{i}(1:end-1,:);
        X_new(j:(j+size(X{i},1)-2),:) =X{i}(2:end,:);
        j = j+size(X{i},1);
    end

    X=X_cont;
    Y=Y_cont;

else
    X_old = X(1:end-1,:);
    X_new = X(2:end,:);

end
A = X_new'*X_old*(X_old'*X_old)^-1;


C = Y'*X*(X'*X)^-1;

%model error covariance
Q = (X_new'*X_new - A*(X_old'*X_new))/length(X_new);

R = (Y'*Y - C*(X'*Y))/length(X);
