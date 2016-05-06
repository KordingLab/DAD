function [R2, Results] = run3Ddad(X3D,Vr,Xte,Ang,Methods,numsol,numInit)

    % 3d DAD
    [R2vals,minval,Res] = calcR2_minKL3Dgrid(Vr,X3D,Xte,Ang,[],Methods,numsol,numInit); % input Methods is optional
    
    R2(1) = R2vals.R2X;
    R2(2) = R2vals.R2Vicp;
    R2(3) = R2vals.R2V;
    R2(4:3+numsol) = R2vals.R2Vf;
    
    Results.Vicp = Res{1}.Vicp;
    Results.Xrec = Res{1}.Xrec;
    Results.Vflip = Res{1}.Vflip;
    Results.KLD = Res{1}.KLD;
    Results.R2 = R2;
    Results.minval = minval;
    
end