function [R2, minVal, Results] = calcR2_minKLgrid(V,X,Xgt,A,K,Methods)
%%%%%%%%
% Required Input:
% V = low-dim embedding (source distribution)
% X = training data (target distribution)
% Xgt = ground truth (true X coresponding to V)
% A = vector of values of numA for testing 3D DAD (number of angles for 2D DAD)
% K = vector of values of K for testing 3D DAD (K for source distribution)
%%%%%%%%
% Optional Input:
% Methods = struct containing dim red methods used (for display)
%%%%%%%%

if ~iscell(V)
    tmp = V; clear V; V{1} = tmp;
end

if length(K)<1
    K = ceil(size(V{1},1)^(1/3));
end

numargin = 5; % num of required inputs

numA = length(A);
numK = length(K);
numV = length(V);
R2 = zeros(numA,numK, numV);
minVal = zeros(numA,numK, numV);

if nargout>2
    Results = cell(numA,numK,numV);
end

svec = 0.8:0.4/19:1.2; % default scaling vector
for i = 1:numA
    avec = -pi:2*pi/(A(i)-1):pi;
    for j=1:numK
        for jj = 1:numV
            if length(K)<1
                K = ceil(size(V{jj},1)^(1/3));
            end
            Res = minKL_grid(V{jj},X,avec,svec,'L2',K(j)); 
            R2(i,j,jj) = max([evalR2(Res.Xrec,Xgt),evalR2(Res.Vflip,Xgt)]); 
            minVal(i,j,jj) = Res.minVal;
            
            if nargout>2
                Results{i,j,jj} = Res;
            end
            
            if nargin>numargin
                display(['numA = ',int2str(A(i)),' , k = ',int2str(K(j)),...
                ' , Method = ', Methods{jj},', R2 = ', num2str(R2(i,j,jj),3)])
            else
                display(['numA = ',int2str(A(i)),' , k = ',int2str(K(j)),...
                ', R2 = ', num2str(R2(i,j,jj),3)])
            end
        end
    end
end

end % end main function
