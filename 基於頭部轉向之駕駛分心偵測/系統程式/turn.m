function direction=turn(m,nF,D)  %�P�_���Y
    if m>1 %�Y���W�U
           if D(1,2)-D(nF,2)>0
              direction = 'D';%�s�J�Ȧs��
           else
              direction = 'U';
           end
    else
           if D(1,1)-D(nF,1)>0%�Y�����k
              direction = 'L';
           else
              direction = 'R';
           end
    end
end