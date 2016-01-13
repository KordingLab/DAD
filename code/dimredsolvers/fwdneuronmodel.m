function out = fwdneuronmodel(x0,pref_dir,magV,theta_dir)
% pref_dir is a scalar between 0:2*pi
% x0 is a scalar baseline value
% X is 2D input (T x 2)

N = length(pref_dir);
T = length(magV);
mnV = mean(magV);

out = exp((repmat(magV./mnV,1,N)').*cos(repmat(theta_dir,1,N)' - repmat(pref_dir,1,T)) + repmat(x0,1,T));

end


