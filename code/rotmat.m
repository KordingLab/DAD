function R=rotmat(x)
%2D Rotation matrix counter-clockwise.
%
%R=R2d(deg)
%
%Input is in degrees.
%
%See also Rx,Ry,Rz,,R3d,M2d,M3d

R= [cosd(x),-sind(x); sind(x),cosd(x)];