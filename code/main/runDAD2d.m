function [Vout, yKL] = runDAD2d(Yr,Xtr,drmethod)

M1{1} = drmethod;
[V,~,~] = computeV(Yr, 3, M1);
[Vout,~, yKL, ~] = rotated_KLmin(V{1}(:,1:2),Xtr(:,1:2),90);

end