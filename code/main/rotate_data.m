function Yrot = rotate_data(Ycurr,an0)

r = vrrotvec([0,0,1],an0);
m = vrrotvec2mat(r);
Yrot = Ycurr*m;
mnY = mean(Yrot);
Yrot = Yrot - repmat(mnY,size(Yrot,1),1);
    
end