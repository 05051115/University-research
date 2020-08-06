function Y = center(B)
x=B(1,1,:,:);
y=B(1,2,:,:);
width=B(1,3,:,:);
Y=[x+width/2,y+width/2];