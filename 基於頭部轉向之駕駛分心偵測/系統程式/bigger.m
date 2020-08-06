function [x1, y1, w1, h1] = bigger(big,box)
    x=box(1,1);
    y=box(1,2);
    w=box(1,3);
    h=box(1,4);
    
    x1=x-w*big/2;
    y1=y-h*big/2;
    w1=w*(1+big);
    h1=h*(1+big);
