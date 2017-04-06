function Y_new = sample_after_gocue(Y,Ttr,numSamp,numDelay)

id = find(diff(Ttr));

Y_new = [];
for i=1:length(id)
    
    if i~=length(id)
        maxT = min(id(i)+numDelay+numSamp,id(i+1));
    else
        maxT = min(id(i)+numDelay+numSamp,size(Y,1));
    end
    Y_new = [Y_new; Y(id(i)+numDelay:maxT,:)];
end

end