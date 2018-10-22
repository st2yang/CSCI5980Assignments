function J=Jacob_C(R,C,X)
M=R*(X-C);
W=M(1,1); Y=M(2,1); Z=M(3,1);
J1=[1/Z, 0, -W/Z^2;
    0, 1/Z, -Y/Z^2];
J2=-R;
J=J1*J2;