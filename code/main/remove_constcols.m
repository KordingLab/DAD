function Y = remove_constcols(Y)

Y(:,find(sum(abs(diff(Y)))==0))=[];


end