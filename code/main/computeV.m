function [V,Methods,mean_resid] = computeV(Y, d, Methods, Xtest, Ttest)
% Required Input:
% Y (T x N data matrix, with T time points + N neurons)
% d = dimension of low-dim embedding
% Methods = struct with methods to test, for default settings, supply []
% Optional input:
% 
% Xtest and Ttest (if one is supplied, both are required to display embeddings)

% Possible methods to test from DR toolbox
%'GDA','SNE','SymSNE','tSNE','LPP','NPE','LLTSA','SPE','LLC',
%'ManifoldChart','CFA','NCA','MCML','LMNN'
% Can also test, 'ExpPCA'
% [V, ~, ~] = ExpFamPCA(Y0,2);

% Default methods (if Methods=[])
%Methods{1} = 'PCA';
%Methods{2} = 'MDS';
%Methods{3} ='FA';
%Methods{4} = 'ProbPCA';
%Methods{5}='Isomap';


% default methods to test
if length(Methods)<1
    Methods{1} = 'PCA';
    Methods{2} = 'MDS';
    %Methods{3} ='GPLVM';
    Methods{3} ='FA';
    Methods{4} = 'ProbPCA';
    Methods{5}='Isomap';
end

L = length(Methods);
mean_resid = zeros(L,1);
V = cell(L,1);
for i=1:L
    
    if strcmp(Methods{i},'ExpPCA')
        [V{i}, ~, ~] = ExpFamPCA(Y,d);
        Map = pinv(Y)*V{i};
    elseif strcmp(Methods{i},'FA')
        [Map,~,~,~,V{i}]  = factoran(Y,d);
    else
        [V{i}, ~] = compute_mapping(Y,Methods{i},d);
        Map = pinv(Y)*V{i};
    end
    Yhat = V{i}*Map';
    mean_resid(i) = norm(Yhat./norm(Yhat,'fro') -Y./norm(Y,'fro'), 'fro');
    %Yhat2 = Yhat - repmat(mean(Yhat')',1,size(Yhat,2));
    %Y2 = Y - repmat(mean(Y')',1,size(Y,2));
    %mean_resid(i) = sum(normcol(Y2) - normcol(Yhat2) ./sqrt(sum(sum(Y2.^2)));
end

if nargin>3
    id1 = ceil(length(V)+1)/ceil(sqrt(length(V)+1));
    id2 = ceil(sqrt(length(V)+1));
    
    figure;
    subplot(id1,id2,1); colorData2014(Xtest,Ttest); title('Ground truth')
    for i=1:length(V)
        subplot(id1,id2,i+1); colorData2014(V{i},Ttest); title(Methods{i})
    end
end

end
