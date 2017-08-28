function [Hinv,Hinv_dad] = visualize_performance_DAD(Xrec,Xte,Yte,Tte,Vout,Xtr,Ttr)

Xn = normal(Xte);
Hinv = Xn(:,1:2)'*pinv(Yte)';
Xr = (Hinv*Yte')'; 
R2oracle = evalR2(Xn(:,1:2),Xr(:,1:2));
Hinv_dad = Xrec'*pinv(Yte)';
Xr = (Hinv_dad*Yte')'; 
R2DAD = evalR2(Xn(:,1:2),Xrec);
R2Rot = evalR2(Xn(:,1:2),Vout(:,1:2));

display(['Oracle = ',num2str(R2oracle,3), ' ... ',...
         'Xrec = ',num2str(R2DAD,3), ' ... ', 'Xrot = ', num2str(R2Rot,3)])

figure, 
subplot(2,2,2), colorData(normal(Xte(:,1:2)),Tte), 
title('Test kinematics')
axis equal

subplot(2,2,1), colorData(normal(Xtr(:,1:2)),Ttr),
title('Training kinematics')

subplot(2,2,3), colorData(Vout,Tte),
title(['Local min closest to H* (R2 = ',num2str(R2Rot,2),')'])
axis equal

subplot(2,2,4), colorData(Xrec(:,1:2),Tte),
title(['Minimum KL solution (R2 = ',num2str(R2DAD,2),')'])
axis equal

end