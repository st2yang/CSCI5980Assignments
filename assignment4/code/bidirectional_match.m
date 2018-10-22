function [matches_a, matches_b] = bidirectional_match(Ia,Ib,ratio)

[fa_12,fb_12] = ratio_match(Ia,Ib,ratio);
[fb_21,fa_21] = ratio_match(Ib,Ia,ratio);

A = [fa_12(:,1:2),fb_12(:,1:2)];
B = [fa_21(:,1:2),fb_21(:,1:2)];

A = A';
B = B';

At = table(A');
Bt = table(B');
Lia = ismember(At,Bt);

fa_bi = fa_12(Lia,:);
fb_bi = fb_12(Lia,:);

matches_a = fa_bi(:,1:2);
matches_b = fb_bi(:,1:2);

end