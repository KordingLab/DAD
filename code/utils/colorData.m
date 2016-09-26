function colorData(X,ID)

idsz=max(ID);
dsz=size(X,2);

for i=0:idsz
    id=(ID==i);
    
    if dsz==3
        plot3( X(id,1),X(id,2) ,X(id,3),  'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 30);
    elseif dsz==2
        plot( X(id,1),X(id,2)  , 'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 30);
    end;
    
  hold on
    
end;