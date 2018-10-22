function epipo_visualization(F,Ia,Ib)

[u,v] = bidirectional_match(Ia,Ib,0.7);

figure(1);
clf;
subplot(1,2,1)
imshow(Ia);
subplot(1,2,2)
imshow(Ib);

c = hsv(200);
for i = 1:5:size(u,1)
    l12 = F'*[v(i,1:2)';1];
    
    d0 = -size(Ia,2);
    d1 = size(Ia,2);
    y1 = -(l12(1)*d0+l12(3))/l12(2);
    y2 = -(l12(1)*d1+l12(3))/l12(2);
    r = randperm(200);
    subplot(1,2,1)
    hold on
    plot(u(i,1), u(i,2), 'o', 'Color', c(r(1),:), 'MarkerFaceColor', c(r(1),:));
    hold on
    plot([d0 d1], [y1 y2], 'Color', c(r(1),:), 'LineWidth', 2);
    
    l12 = F*[u(i,1:2)';1];
    
    d0 = -size(Ia,2);
    d1 = size(Ia,2);
    y1 = -(l12(1)*d0+l12(3))/l12(2);
    y2 = -(l12(1)*d1+l12(3))/l12(2);
    subplot(1,2,2)
    hold on
    plot(v(i,1), v(i,2), 'o', 'Color', c(r(1),:), 'MarkerFaceColor', c(r(1),:));
    hold on
    plot([d0 d1], [y1 y2], 'Color', c(r(1),:), 'LineWidth', 2);
end

end