function [Rset, Cset] = InterpolateCoordinate(R1, C1, R2, C2, n)

Cx = linspace(C1(1), C2(1), n+1);
Cy = linspace(C1(2), C2(2), n+1);
Cz = linspace(C1(3), C2(3), n+1);

Cset = [Cx; Cy; Cz];

w = 0 : 1/n : 1;
q1 = Rotation2Quaternion(R1);
q2 = Rotation2Quaternion(R2);

omega = acos(q1'*q2);
for i = 1 : length(w)
    q = sin(omega*(1-w(i)))/sin(omega) * q1 + sin(omega*w(i))/sin(omega) * q2;
    Rset{i} = Quaternion2Rotation(q);
end


