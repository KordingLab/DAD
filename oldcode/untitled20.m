p_rot = prob_grid(normal(VLr{328}),bsz,k);
im_rot = probmap2im(p_rot,bsz);
t0 = xcorr2(im_rot,im_rot);
t1 = xcorr2(im_train,im_rot)./norm(t0(:));
max(t1(:))

p_rot = prob_grid(normal(VLr{minInd}),bsz,k);
im_rot = probmap2im(p_rot,bsz);
t0 = xcorr2(im_rot,im_rot);
t1 = xcorr2(im_train,im_rot)./norm(t0(:));
max(t1(:))