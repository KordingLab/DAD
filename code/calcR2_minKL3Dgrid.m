function [R2, minVal, Results] = calcR2_minKL3Dgrid(V,X,Xgt,A,K,Methods,numsol,numInit)
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
R2X = zeros(numA,numK, numV);
R2V = zeros(numA,numK, numV);
R2Vicp = zeros(numA,numK, numV);
minVal = zeros(numA,numK, numV);

if numsol>0
    R2Vf = zeros(numsol,numA,numK, numV);
else
    R2Vf = 0;
end

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
            Res = minKL_grid3D(V{jj},X,numInit); % main function
            
            if ~isempty(Xgt)
                R2X(i,j,jj) = evalR2(Res.Xrec,Xgt); 
                
                if numsol>0
                    for mm = 1:numsol
                        R2Vf(mm,i,j,jj) = evalR2(Res.Vflip{mm},Xgt); 
                    end
                end
                R2V(i,j,jj) = evalR2(Res.V(:,1:2),Xgt); 
                R2Vicp(i,j,jj) = evalR2(Res.Vicp(:,1:2),Xgt); 
            end
                
            minVal(i,j,jj) = Res.minVal;
            
            if numsol>0
                tmpr2 = R2Vf(:,i,j,jj);
                [R2max,~] = max([R2X(i,j,jj), tmpr2(:)', R2V(i,j,jj), R2Vicp(i,j,jj)]);
                
                figure; 
                subplot(2,4,1), 
                plot(Res.Xrec(:,1),Res.Xrec(:,2),'*');
                subplot(2,4,2), 
                plot(Res.Vicp(:,1),Res.Vicp(:,2),'*');
                for kk=1:5
                    subplot(2,4,i), 
                    plot(Res.Vflip{kk}(:,1),Res.Vflip{kk}(:,2),'*');
                end
            
            else
                [R2max,~] = max([R2X(i,j,jj), R2V(i,j,jj), R2Vicp(i,j,jj)]);
                
                figure; 
                subplot(1,2,1), 
                plot(Res.Xrec(:,1),Res.Xrec(:,2),'*');
                subplot(1,2,2), 
                plot(Res.Vicp(:,1),Res.Vicp(:,2),'*');
              
            end
        
            if nargout>2
                Results{i,j,jj} = Res;
            end
            
            if nargin>numargin
                display(['numA = ',int2str(A(i)),' , k = ',int2str(K(j)),...
                ' , Method = ', Methods{jj},', R2 = ', num2str(R2max,3)])
            else
                display(['numA = ',int2str(A(i)),' , k = ',int2str(K(j)),...
                ', R2 = ', num2str(R2max,3)])
            end
        end
    end
end

R2.R2X = R2X;
R2.R2V = R2V;
R2.R2Vf = R2Vf;
R2.R2Vicp = R2Vicp;


end % end main function
