function [V,Methods] = computeV(Y, d, Methods, Xtest, Ttest)
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
% Can also test,
% [V, ~, ~] = ExpFamPCA(Y0,2);

% default methods to test
if length(Methods)<1
    Methods{1} = 'PCA';
    Methods{2} = 'MDS';
    Methods{3} ='GPLVM';
    Methods{4} = 'ProbPCA';
    Methods{5}='Isomap';
end

V = cell(length(Methods),1);
for i=1:length(Methods)
    
    if strcmp(Methods{i},'ExpPCA')
        [V{i}, ~, ~] = ExpFamPCA(Y,d);
    elseif strcmp(Methods{i},'FA')
        [~,~,~,~,V{i}]  = factoran(Y,d);
    else
        [V{i}, ~] = compute_mapping(Y,Methods{i},d);
    end
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
