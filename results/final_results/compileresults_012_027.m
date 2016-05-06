% compiles results from variabletestDAD
% script_3D_within_subject_variabletest
count=1;
for j=1:5
    load(['Results-16-Feb-2016-psamp-15-numIter-20-remove-012-(',int2str(j),').mat'])

    R2vals = zeros(11,9,20);
    for i=1:20
        R2vals(:,:,i) = R2{i};
    end
    
    for i=1:20
        r012(:,count) = max(R2vals(1:8,:,i)); 
        rsup012(:,:,count) = R2vals(9:11,:,i); 
        count = count+1;
    end
end

count=1;
for j=1:4
    load(['Results-16-Feb-2016-psamp-15-numIter-20-remove-027-(',int2str(j),').mat'])
    L = length(R2);
    R2vals = zeros(11,9,L);
    for i=1:L
        R2vals(:,:,i) = R2{i};
    end
    
    for i=1:L
        r027(:,count) = max(R2vals(1:8,:,i)); 
        rsup027(:,:,count) = R2vals(9:11,:,i); 
        count = count+1;
    end
end

createfigure(round(percent_test*1050),...
    [median(r012');median(r027');median(rsup012,3)])

figure; plot(round(percent_test*1050),median(r012'),'LineWidth',2); 
hold on; plot(round(percent_test*1050),median(r027'),'LineWidth',2);
plot(round(percent_test*1050),median(rsup012,3)','LineWidth',2);
plot(round(percent_test*1050),median(rsup027,3)','LineWidth',2);
legend('DAD (P1)','DAD (P2)','DAD + Sup','Supervised','Oracle')
axis tight
