function s = computestats(Y)

if size(Y,1)>1
    s = [median(max(Y)), mean(max(Y)), min(max(Y)), ...
         max(max(Y)), std(max(Y)), sum(max(Y)>0)/size(Y,2)] ;
else
    s = [median(Y), mean(Y), min(Y), ...
         max(Y), std(Y), sum(Y>0)/length(Y)] ;
end

end