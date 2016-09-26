function err = error_nocenter(p_train,p_rot,dim,num)

if nargin<4
    num=1;
end

if dim==3
    L =round(size(p_train,1)^(1/3));
    pt = reshape(p_train,L,L,L);
    pr = reshape(p_rot,L,L,L);

    bd = zeros(L,L,L);
    bd(round(L/2)-num:round(L/2)+num,round(L/2)-num:round(L/2)+num,round(L/2)-num:round(L/2)+num)=1;

elseif dim==2
    L =round(size(p_train,1)^(1/2));
    pt = reshape(p_train,L,L);
    pr = reshape(p_rot,L,L);

    bd = zeros(L,L);
    bd(round(L/2)-num:round(L/2)+num,round(L/2)-num:round(L/2)+num)=1;
end
    
idx = find(bd~=1);

err = norm(pt(idx)-pr(idx))./norm(pr(idx));


end