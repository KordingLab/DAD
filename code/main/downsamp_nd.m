function Yout = downsamp_nd(Y,L)

if L>1
    Yout = zeros(size(Y));
    for i=1:size(Y,2)
        out = conv(Y(:,i),ones(L,1));
        Yout(:,i) = out(1:size(Y,1));
    end
else
    Yout = Y;
end

end
