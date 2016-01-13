function [rotData,im_rot] = findrotmtx(X,Y,bsz,k)

p_train = prob_grid(normal(X-repmat(mean(X)',1,size(X,1))'),bsz,k);
im_train = probmap2im(p_train,bsz);

% rotate data
[rotData,im_rot] = rotim(Y,im_train,bsz,k); % dont need to normalize Y here

% rotate flipped data
fm = [-1,0;0,1];
[rotDataf,im_rotflip] = rotim((fm*Y')',im_train,bsz,k);

[~,id] = min([norm(im_rot(:)-im_train(:))/norm(im_train(:)), ...
              norm(im_rotflip(:)-im_train(:))/norm(im_train(:))]);
     
figure; 
subplot(2,2,1); pm = 0; 
Data = normal(rotData*[cos(pm),-sin(pm);sin(pm),cos(pm)]); 
plot(Data(:,1),Data(:,2),'^'); hold on;
Data = normal(X);
plot(Data(:,1),Data(:,2),'^'); hold off;

          
subplot(2,2,1); pm = -pi/2; 
Data = normal(rotData*[cos(pm),-sin(pm);sin(pm),cos(pm)]); 
plot(Data(:,1),Data(:,2),'^'); hold on;
Data = normal(X);
plot(Data(:,1),Data(:,2),'^'); hold off;

subplot(2,2,3); pm = 0; 
Data = normal(rotDataf*[cos(pm),-sin(pm);sin(pm),cos(pm)]); 
plot(Data(:,1),Data(:,2),'^'); hold on;
Data = normal(X);
plot(Data(:,1),Data(:,2),'^'); hold off;

          
subplot(2,2,4); pm = -pi/2; 
Data = normal(rotDataf*[cos(pm),-sin(pm);sin(pm),cos(pm)]); 
plot(Data(:,1),Data(:,2),'^'); hold on;
Data = normal(X);
plot(Data(:,1),Data(:,2),'^'); hold off;
          
          
 if id==2
     rotData = normal(rotDataf);
     im_rot = im_rotflip;
 else
     rotData = normal(rotData);
 end    
          
end % end main function


function [rotData,im_rot] = rotim(Y,im_train,bsz,k)
thr = 4;

[p_test,gridsz] = prob_grid(normal(Y-repmat(mean(Y)',1,size(Y,1))'),bsz,k);
im_test = probmap2im(p_test,bsz);
thr=3;
%tform = imregcorr(im_test.*(im_test>thr),im_train.*(im_train>thr));
%tform = imregcorr(im_test,im_train);


%TT = tformfwd(tform.T,Y(:,1),Y(:,2));
[optimizer, metric] = imregconfig('multimodal');
Roptimizer.MaximumIterations = 300;
optimizer.InitialRadius = 0.005; % only for MULTIMODAL optimizer
tform = imregtform(im_test.*(im_test>thr), im_train.*(im_train>thr),...
    'affine', optimizer, metric);



tformInv = invert(tform); 

TF = tformInv.T;
R = TF(1:2,1:2);
T = TF(1:2,3).*gridsz';

%rotData = (R*normal(Y)')' + repmat(T,1,size(Y,1))';
%rotData = (normal(Y)*R);
rotData = (R*normal(Y)')';
p_rot = prob_grid(normal(rotData),bsz,k);
im_rot = reshape(log(p_rot) + abs(min(log(p_rot))),bsz,bsz);

end