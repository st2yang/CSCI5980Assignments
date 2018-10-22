function q = Rotation2Quaternion(R)

m00 = R(1,1); m01 = R(1,2); m02 = R(1,3);
m10 = R(2,1); m11 = R(2,2); m12 = R(2,3);
m20 = R(3,1); m21 = R(3,2); m22 = R(3,3);

qw= sqrt(1 + m00 + m11 + m22) /2;
qx = (m21 - m12)/( 4 *qw);
qy = (m02 - m20)/( 4 *qw);
qz = (m10 - m01)/( 4 *qw);

q = [qw; qx; qy; qz];