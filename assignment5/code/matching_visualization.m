function matching_visualization(Ia,Ib,matches_a,matches_b)

dh1 = max(size(Ia,1)-size(Ia,1),0) ;
dh2 = max(size(Ia,1)-size(Ib,1),0) ;

figure();
imagesc([padarray(Ia,dh1,'post') padarray(Ib,dh2,'post')]) ;
line([matches_a(:,1)';matches_b(:,1)'+size(Ia,2)],...
     [matches_a(:,2)';matches_b(:,2)'],'Color','green','Marker','o');

end