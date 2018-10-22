function J=Jacob_X(R,C,X)
% r11=R(1,1);r12=R(1,2);r13=R(1,3);r21=R(2,1);r22=R(2,2);r23=R(2,3);r31=R(3,1);r32=R(3,2);r33=R(3,3);
% c1=C(1,1);c2=C(2,1);c3=C(3,1);
% x1=X(1,1);x2=X(2,1);x3=X(3,1);
M=R*(X-C);
W=M(1,1); Y=M(2,1); Z=M(3,1);
J1=[1/Z, 0, -W/Z^2;
    0, 1/Z, -Y/Z^2];
J2=R;
J=J1*J2;
end

% syms  r11 r12 r13 r21 r22 r23 r31 r32 r33 x1 x2 x3 c1 c2 c3 th1 th2 th3;
% syms W Y Z;
% u=W/Z;
% v=Y/Z;
% R=[r11,r12,r13;
%    r21,r22,r23;
%    r31,r32,r33];
% X=[x1,x2,x3]';
% C=[c1,c2,c3]';
% J1_var=jacobian([u,v],[W,Y,Z]);
% R0=Quaternion2Rotation(Q0);
% M0=R0*(X0-C0);
% W0=M0(1,1); Y0=M0(2,1); Z0=M0(3,1);
% J1=double(subs(J1_var, {W Y Z}, {W0 Y0 Z0}));
% M=R*(X-C);
% W=M(1,:);
% Y=M(2,:);
% Z=M(3,:);
% J2_var=jacobian([W,Y,Z],[x1,x2,x3])f
% 
% 
% r110=R0(1,1);r120=R0(1,2);r130=R0(1,3);r210=R0(2,1);r220=R0(2,2);r230=R0(2,3);r310=R0(3,1);r320=R0(3,2);r330=R0(3,3);
% 
% %J=2;
% 
% J2=double(subs(J2_var, {r11 r12 r13 r21 r22 r23 r31 r32 r33}, {r110 r120 r130 r210 r220 r230 r310 r320 r330}));
% J=J1*J2;
%subs(J_var, {r11 r12 r13 r21 r22 r23 r31 r32 r33 W Y Z}, {r110 r120 r130 r210 r220 r230 r310 r320 r330 W0 Y0 Z0})


