function [Xout,Yout,Tout] = permutetrials(X,Y,T)

whichT = find(diff(T));
permz = randperm(length(whichT)+1);

ID=[];
for i=1:length(whichT)
    
    if permz(i)==1
        ID = [ID, 1:whichT(1)];
    elseif permz(i)==length(permz)
        ID = [ID, whichT(permz(i)-1)+1:size(T,1)];
    else
        ID = [ID, whichT(permz(i)-1)+1:whichT(permz(i))];
    end
    
end

Xout = X(ID,:);
Yout = Y(ID,:);
Tout = T(ID);


end