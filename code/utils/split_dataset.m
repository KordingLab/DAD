function [ID1,ID2] = split_dataset(T,psamp)


num1 = round(psamp*length(T));
tmp = find(diff(T));
[~,idd] = min(abs(tmp - ones(length(tmp),1)*num1 ));
whichID = tmp(idd);
    
ID1 = 1:whichID;
ID2 = whichID+1:length(T);

end