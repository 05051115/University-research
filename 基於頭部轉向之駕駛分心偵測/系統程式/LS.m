function m=LS(nF,D) %最小平方法
    
     xm=0;
     ym=0;
     ss1=0;
     ss2=0;
     
     
     for t=1:nF   %算平均
         xm=xm+D(t,1);
         ym=ym+D(t,2);
     end
     
     xm=xm/nF;
     ym=ym/nF;
         
     for r=1:nF
         xk=D(r,1);
         yk=D(r,2);
         s1=(xk-xm)*(yk-ym);
         s2=(xk-xm)^2;
         ss1=ss1+s1;
         ss2=ss2+s2;
     end
     m=ss1/ss2;