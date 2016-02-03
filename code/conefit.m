function [Vcurr,res] = conefit(Xn,Vcurr)

% iterative cone fitting routine
maxIter = 20;
nmdiff = zeros(maxIter,1);
for i=1:maxIter
    [~, ~, Vr,res] = icp(Xn',Vcurr'); Vr = Vr'; % align point clouds first
    Vout = correctCone(Vr); % fit a cone to V2n
    nmdiff(i) = norm(Vout(:)-Vcurr(:));
    Vcurr = Vout;
    if nmdiff(i)<1e-5
        break
    end
end % end iterations (loop between ICP and cone fitting)

end

function Xout = correctCone(Xn)

[x0n, an] = lscone(Xn,median(Xn)',[0 0 1]',pi/8, 1, 1e-5, 1e-5);
%[x0n, an] = lscone(Xn,[0,0,0]',[0 0 1]',pi/8, 1, 1e-5, 1e-5);
Xout(:,1) = Xn(:,1) - x0n(1);
Xout(:,2) = Xn(:,2) - x0n(2);
Xout(:,3) = Xn(:,3) - x0n(3);

r = vrrotvec([0,0,1],an);
m = vrrotvec2mat(r);

Xout = Xout*m;



end
