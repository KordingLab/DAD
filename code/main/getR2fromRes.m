function R2 = getR2fromRes(Xte,V)

if size(Xte,2)==2
    R2 = evalR2(V,mapX3D(Xte));
elseif size(Xte,2)==3
    
    if size(V,2)==2
        R2 = evalR2(mapX3D(V),normal(Xte));
    else
         R2 = evalR2(V,normal(Xte));
    end
end
    
end

