function vl_match(Ia,Ib)

Ia1 = single(rgb2gray(Ia));
[fa,da] = vl_sift(Ia1);
Ib1 = single(rgb2gray(Ib));
[fb,db] = vl_sift(Ib1);
[matches, ~] = vl_ubcmatch(da, db);

dh1 = max(size(Ia,1)-size(Ia,1),0) ;
dh2 = max(size(Ia,1)-size(Ib,1),0) ;

figure();
imagesc([padarray(Ia,dh1,'post') padarray(Ib,dh2,'post')]) ;
line([fa(1,matches(1,:));fb(1,matches(2,:))+size(Ia,2)],...
     [fa(2,matches(1,:));fb(2,matches(2,:))],'Color','blue');

end