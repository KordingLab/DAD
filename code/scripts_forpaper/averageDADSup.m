function Xave = averageDADSup(Res,Xsup,wt)

if nargin<3
    wt = 0.5;
end

[~,id] = max(Res.R2);
if id==1
    Xave = 0.5*(Xsup + Res.Xrec);
elseif id == 2
    Xave = 0.5*(Xsup + Res.Vicp);
elseif id > 3
    Xave = wt*(Xsup + Res.Vflip{id-3});
end

end