% Normalize columns of Y
function [Y,yMag] = normcol(Y,varargin)

if nargin>1
    nm = varargin{1};
else
    nm = 2;
end

if nargin>2
    yMag = varargin{2}; % pass in vector to scale columns by
    
else % compute norms
    % compute p-norm of columns (p = nm)
    switch nm
        case 2
            yMag = sqrt(sum(Y.^2)); 
        case 1
            yMag = sum(abs(Y)); 
    end
end
    

    Y = Y./yMag(ones(1,size(Y,1)),:);

        

end