function vec = create_gaparray(gap,size)

vec= (1:1:gap*size)';

for i = 0:size-1
   
    vec(gap*i+1:gap*i+2,:) = vec(gap*i+1:gap*i+2,:)+gap*i;
    
end

end