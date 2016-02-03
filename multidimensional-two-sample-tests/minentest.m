% minentest                  N-dimensional, 2-sample comparison of 2 distributions
% 
%     [p,phi_nm] = minentest(x,y,nboot);
%
%     Compares d-dimensional data from two samples using a measure based on
%     statistical energy. The test is non-parametric, does not require binning
%     and easily scales to arbitrary dimensions.
%
%     The analytic distribution of the statistic is unknown, and p-values
%     are estimated using a permutation procedure, which works well
%     according to simulations by Aslan & Zech.
%
%     INPUTS
%     x - [n1 x d] matrix
%     y - [n2 x d] matrix
%
%     OUTPUTS
%     p - p-value by permutation
%     D - minimum energy statistic
%
%     REFERENCE
%     Aslan, B, Zech, G (2005) Statistical energy as a tool for binning-free
%       multivariate goodness-of-fit tests, two-sample comparison and unfolding.
%       Nuc Instr and Meth in Phys Res A 537: 626-636
%
%     SEE ALSO
%     kstest2d

%     $ Copyright (C) 2011 Brian Lau http://www.subcortex.net/ $
%
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
%     REVISION HISTORY:
%     brian 08.25.11 written

function [p,phi_nm] = minentest(x,y,nboot);

if nargin < 3
   nboot = 1000;
end

n = length(x);
m = length(y);

phi_nm = r_log(x,n,y,m);

xy = [x ; y];
phi_nm_boot = zeros(nboot,1);
for i = 1:nboot
   ind = randperm(n+m);
   phi_nm_boot(i) = r_log(xy(ind(1:n),:),n,xy(ind(n+1:end),:),m);
end

p = sum(phi_nm_boot>phi_nm)./nboot;

function z = r_log(x,n,y,m);

a = -log(pdist(x,'euclidean'));
b = -log(pdist(y,'euclidean'));
c = -log(pdist2(x,y,'euclidean'));
z = (1/(n*(n-1)))*sum(a) + (1/(m*(m-1)))*sum(b) - (1/(n*m))*sum(c(:));
