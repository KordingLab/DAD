function colorData(X,ID)

cmp = colormap(parula(12));
idsz=max(ID);
dsz=size(X,2);

for i=0:idsz
    id=(ID==i);
    
    if dsz==3
%         hold on
%         scatter3(X(id,1),X(id,2),X(id,3),'MarkerFaceColor',cmp(2*i + 1,:),'MarkerEdgeColor','k',...
%             'MarkerFaceAlpha',.2,'MarkerEdgeAlpha',.05)
%         hold off
        plot3( X(id,1),X(id,2) ,X(id,3),  'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 30);
    elseif dsz==2
        %hold on
%         scatter(X(id,1),X(id,2),'MarkerFaceColor','r','MarkerEdgeColor','r',...
%             'MarkerFaceAlpha',.2,'MarkerEdgeAlpha',.2)
%         hold off
        plot( X(id,1),X(id,2)  , 'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 30);
    end;
    
  hold on
    
end;