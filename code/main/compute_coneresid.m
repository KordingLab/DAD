function [Xout,resid] = compute_coneresid(Vcurr,Xn,an0)

r = vrrotvec([0,0,1],an0);
m = vrrotvec2mat(r);
V2 = Vcurr*m;
        
minV = min(V2);  
V2(:,1) = V2(:,1) - minV(1);
V2(:,2) = V2(:,2) - minV(2);
V2(:,3) = V2(:,3) - minV(3);
V2 = normal(V2);

[xnew, anew] = lscone(V2,[0,0,0]',[0,0,1], pi/8, pi/3, 1e-5, 1e-5);
        
Xout(:,1) = V2(:,1) - xnew(1);
Xout(:,2) = V2(:,2) - xnew(2);
Xout(:,3) = V2(:,3) - xnew(3);

r = vrrotvec([0,0,1],anew);
m = vrrotvec2mat(r);

Xout2 = Xout*m;
[~,~,Xout3,resid] = icp(Xn',Xout2');
Xout = Xout3';
%[Xout, ~,~,resid] = icp(Xn',normal(V2)');


% figure, 
% plot3(Xn(:,1),Xn(:,2),Xn(:,3),'o','MarkerSize',5)
% hold on, plot3(Xout2(:,1),Xout2(:,2),Xout2(:,3),'rx','MarkerSize',5)
% title(num2str(resid,3))

end