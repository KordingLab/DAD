
The ICP algorithm

This is a short documatation about the ICP (iterative closest point) algorithm implemented in "icp.m". Examples of its simplest
usage are found in "example.m" and "example2.m" where least squares point-to-point minimization are used, see [Besl & McKay 1992].
In addition to least squares minimization other criterion functions are implemented as well. These are:

 1) Huber criterion function (robust)
 2) Tukey's bi-weight criterion function (robust)
 3) Cauchy criterion function (robust)
 4) Welsch criterion function (robust)   

An example where Welsch criterion function is used is found in "example3.m". More information about the robust IRLS-ICP algorithm
is given in [Bergström & Edlund 2014]. See also the documentation about "icp.m" by running "help icp" in Matlab.



Reference:

[Bergström & Edlund 2014]

Bergström, P. and Edlund, O. 2014, 'Robust registration of point sets using iteratively reweighted least squares'
Computational Optimization and Applications, vol 58, no. 3, pp. 543-561., 10.1007/s10589-014-9643-2



__________________________________________________________________________________________________________________________________




YouTube:  Real time 3D shape analysis by comparing point cloud with CAD-model

An example where an ICP-algorithm is used can be seen on YouTube,


https://youtu.be/lm7_mwpOk0E


A demonstration of shape matching, shape comparison, and shape identification is presented.

The IGES-toolbox is used to read the CAD-models into Matlab,


http://www.mathworks.com/matlabcentral/fileexchange/13253-iges-toolbox