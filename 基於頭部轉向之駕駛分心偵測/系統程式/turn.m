function direction=turn(m,nF,D)  %判斷轉頭
    if m>1 %頭部上下
           if D(1,2)-D(nF,2)>0
              direction = 'D';%存入暫存器
           else
              direction = 'U';
           end
    else
           if D(1,1)-D(nF,1)>0%頭部左右
              direction = 'L';
           else
              direction = 'R';
           end
    end
end