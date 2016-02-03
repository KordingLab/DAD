function [Xout,res] = conefit2(X,V,maxIter)
% target (X) and source (V) data
Xn = normal(X); % target

[~, ~, Vr,res] = icp(Xn',V'); % align source to target
Vcurr = Vr'; % align point clouds first

nmtol = 1e-4;

if nargin<3
    maxIter = 2;
end

numA = 1;
oldval = 1;

% figure;
% subplot(2,3,1); 
% plot3(Xn(:,1),Xn(:,2),Xn(:,3),'*'); 
% hold on; plot3(Vcurr(:,1),Vcurr(:,2),Vcurr(:,3),'ro'); 

for nn=1:maxIter
    
    an0 = [randn(numA-3,3); 0,0,1; 0,1,0; 1,0,0];
    an0 = normcol(an0');

    for i=1:numA
        
        r = vrrotvec([0,0,1],an0(:,i));
        m = vrrotvec2mat(r);
        V2 = Vcurr*m;
        
        minV = min(Vcurr);  
        V2(:,1) = V2(:,1) - minV(1);
        V2(:,2) = V2(:,2) - minV(2);
        V2(:,3) = V2(:,3) - minV(3);
        V2 = normal(V2);
        
        [xnew, anew] = lscone(V2,[0,0,0]',[0,0,1], pi/8, pi/3, 1e-5, 1e-5);
        
        %[x0n, an] = lscone(Xn,[0,0,0]',[0 0 1]',pi/8, 1, 1e-5, 1e-5);
        Xout(:,1) = V2(:,1) - xnew(1);
        Xout(:,2) = V2(:,2) - xnew(2);
        Xout(:,3) = V2(:,3) - xnew(3);

        r = vrrotvec([0,0,1],anew);
        m = vrrotvec2mat(r);

        Xout = Xout*m;
        [~, ~,~,res(i)] = icp(Xn',Xout'); 
        clear Xout
    end

    [newval,id] = min(res);

    % apply transformation with lowest residual
    [xnew, anew] = lscone(Vcurr,[0,0,0]',an0(:,id),pi/6, pi/2, 1e-5, 1e-5);
    Xout(:,1) = Vcurr(:,1) - xnew(1);
    Xout(:,2) = Vcurr(:,2) - xnew(2);
    Xout(:,3) = Vcurr(:,3) - xnew(3);

    r = vrrotvec([0,0,1],anew);
    m = vrrotvec2mat(r);
    Xout = Xout*m;
    
    nmdiff = norm(oldval-newval);
    
    if (nmdiff<nmtol)
        return
    end
    
    oldval = newval;
    
    %if nn>1
    %    if nmdiff(nn)>nmdiff(nn-1)
    %        return
    %    end
    %end
    
    [~, ~, Vr,res] = icp(Xn',Xout'); % align source to target
    Vcurr = Vr'; % align point clouds first
    
%     subplot(2,3,nn+1); 
%     plot3(Xn(:,1),Xn(:,2),Xn(:,3),'*'); 
%     hold on; plot3(Vcurr(:,1),Vcurr(:,2),Vcurr(:,3),'ro'); 
%     pause,

end

end
