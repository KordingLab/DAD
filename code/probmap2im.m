function im = probmap2im(p,bsz)

im = flipud(reshape(log(p) + abs(min(log(p))),bsz,bsz));
    
end