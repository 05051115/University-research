%�j��X
clear all;
clear vid;

vid = videoinput('winvideo',1,'YUY2_640x480');    %�إ�video input object  'YUY2_640x480'  'MJPG_1024x576'
%preview(vid)
set(vid,'TriggerRepeat',Inf); % �]�wvideo input����Ѽ�
vid.FrameGrabInterval = 10;    %�]�w�I���ɶ����Z
vid.ReturnedColorSpace='grayscale';

faceDetector = vision.CascadeObjectDetector;
faceDetector.MinSize = [200 200];
faceDetector.MergeThreshold=10;

eyeDetector = vision.CascadeObjectDetector('EyePairBig');
%faceDetector.MinSize = [130 130];
eyeDetector.MergeThreshold=10;  

ReyeDetector = vision.CascadeObjectDetector('RightEye');
ReyeDetector.MinSize = [40 40];
ReyeDetector.MergeThreshold=0;

LeyeDetector = vision.CascadeObjectDetector('LeftEye');
LeyeDetector.MinSize = [40 40];
LeyeDetector.MergeThreshold=0;
i=0;
B=[];


pause;
start(vid)%�}�l�I��frame
nF=30/vid.FrameGrabInterval;  %�]�w�H�X�V�@�����
Face_center=[ones(nF,2)];
mm=[];
Diss=[];
buffer=[];
eyes=[];
center_Face=[];
center_Eyes=[];
D=zeros(nF,2);
page=30/vid.FrameGrabInterval;
warm_sec=zeros(page,1);
%WARMING=zeros(page,1);
distr=page*0.8;
warm_count=0;
distime=0;
WARMINGING=[];
time=60*page;%60��
while(i<time) 
    
 i=i+1;
 img=getdata(vid,1,'uint8');
 %img=(v);%rgb2gray im2bw imbinarize
 bboxes = faceDetector(img);
 IFace = insertObjectAnnotation(img,'rectangle',bboxes,'Face');
 
%!!!!!!!!!!��������H�y
 if isempty(bboxes)
     warm_sec=[warm_sec;1];
     warm_sec=warm_sec(2:page+1);
     WARMING=['NoFace '];
     E = zeros(1,4);
     bboxes=zeros(1,4);
     %imshow(img);
      if i>=nF
        u=1;
          while Face_center(u,:)==0  %���L�S����y���A�^�h
                u=u+1; 
          end
        D = Face_center(u:nF+u-1,:);%�� 1~10����ư��B��
     
        m=LS(nF,D); %�̤p����k�D�ײv
        %mm=[m;mm];%�[��ײv���{
        Diss=turn(m,nF,D);

      end  

 else
     Diss='F';
     E = [bboxes];
     bigface=img(fix(bboxes(1,2)):fix(bboxes(1,2)+bboxes(1,4)),fix(bboxes(1,1)):fix(bboxes(1,1)+bboxes(1,3)));
     bboxes_eye = eyeDetector(bigface);
          
%!!!!!!!!!!��������j��
     if isempty(bboxes_eye)
         warm_sec=[warm_sec;1];
         warm_sec=warm_sec(2:page+1);
         WARMING=['NoBgEye'];
         bboxes_eye=zeros(1,4);
         %imshow(IFace);

     else
         bboxes_eyebig=0.2;
         bboxes_eye=[bboxes_eye(1,1)+bboxes(1,1) bboxes_eye(1,2)+bboxes(1,2) bboxes_eye(1,3) bboxes_eye(1,4)];
         [ex,ey,ew,eh]=bigger(bboxes_eyebig, bboxes_eye);
         bboxes_eye=[ex,ey,ew,eh];
         IEyes= insertObjectAnnotation(IFace,'rectangle',bboxes_eye,'EYES');
         %%%%%%%%%�����k���خ�
         Rbigeye=img(fix(bboxes_eye(1,2)) : fix(bboxes_eye(1,2)+bboxes_eye(1,4)) , fix(bboxes_eye(1,1)+bboxes_eye(1,3)/2) : fix(bboxes_eye(1,1)+bboxes_eye(1,3)));
         Lbigeye=img(fix(bboxes_eye(1,2)) : fix(bboxes_eye(1,2)+bboxes_eye(1,4)) , fix(bboxes_eye(1,1)) : fix(bboxes_eye(1,1)+bboxes_eye(1,3)/2));
         bboxes_Reye = ReyeDetector(Rbigeye);
         bboxes_Leye = LeyeDetector(Lbigeye);
         
%!!!!!!!!!!������������
         if isempty(bboxes_Reye) || isempty(bboxes_Leye)
             warm_sec=[warm_sec;1];
             warm_sec=warm_sec(2:page+1);
             WARMING=['NoEyes '];
             %imshow(IEyes);

         else
             %��z�ܼ�
             x=bboxes_Reye(1,1)+bboxes_eye(1,1)+bboxes_eye(1,3)/2;
             y=bboxes_Reye(1,2)+bboxes_eye(1,2);
             w=bboxes_Reye(1,3);
             h=bboxes_Reye(1,4);
             bboxes_Reye=[x y w h];
             
             x1=bboxes_Leye(1,1)+bboxes_eye(1,1);
             y1=bboxes_Leye(1,2)+bboxes_eye(1,2);
             w1=bboxes_Leye(1,3);
             h1=bboxes_Leye(1,4);
             bboxes_Leye=[x1 y1 w1 h1];
             
             %%% ����ҩ�j %%%             
             big=0.5; 
             [rx, ry, rw, rh]=bigger(big,bboxes_Reye);
             [lx, ly, lw, lh]=bigger(big,bboxes_Leye);
             eyes=[rx ry rw rh ; lx ly lw lh];
             %%%            %%%
            
             
             Eyes= insertObjectAnnotation(IEyes,'rectangle',eyes,{'REYE' 'LEYE'});
             
             %������
             rmin=fix(rh/5);
             rmax=fix(rh/3);
 
             Reye=img(fix(ry):fix(ry+rh),fix(rx):fix(rx+rw));%�^�������ؽd��
             Leye=img(fix(ly):fix(ly+lh),fix(lx):fix(lx+lw));
 

             [Rcenters, Rradii] = imfindcircles(Reye,[rmin,rmax],'ObjectPolarity',...
                 'dark','Sensitivity',0.98,'EdgeThreshold',0.7);%,'Sensitivity',1,'EdgeThreshold',0.3
             [Lcenters, Lradii] = imfindcircles(Leye,[rmin,rmax],'ObjectPolarity',...
                 'dark','Sensitivity',0.98,'EdgeThreshold',0.7);%,'Sensitivity',1,'EdgeThreshold',0.3

%!!!!!!!!!!������������
             if isempty(Rradii) || isempty(Lradii)
                 warm_sec=[warm_sec;1];
                 warm_sec=warm_sec(2:page+1);
                 WARMING=['CLOSE  '];
                 %imshow(Eyes);
             else
                 Rradii=Rradii(1,1);
                 Lradii=Lradii(1,1);
                 Rcenters=[Rcenters(1,1)+rx,Rcenters(1,2)+ry];%���[�^��y��
                 Lcenters=[Lcenters(1,1)+lx,Lcenters(1,2)+ly];
                 
                 
                 %------- ���y���� ---------
                 center_Face=center(bboxes);
                 center_Eyes=[(Rcenters(1,1)+Lcenters(1,1))/2, (Rcenters(1,2)+Lcenters(1,2))/2];
                 %imshow(Eyes);
                 
                 Eyesdistraction=abs(center_Eyes(1,1)-center_Face(1,1))/center_Face(1,1);
                 Eyesdistractionup=abs(center_Eyes(1,2)-center_Face(1,2))/center_Face(1,2);
                 if(Eyesdistraction>0.04 || Eyesdistractionup>0.27)
                     warm_sec=[warm_sec;1];
                     warm_sec=warm_sec(2:page+1);
                     WARMING=['Eyesdis'];
                 else
                     warm_sec=[warm_sec;0];
                     warm_sec=warm_sec(2:page+1);
                     WARMING=['SAFE   '];
                 end
                 %------- ���y���� ---------end
                 
                
                 %viscircles(Rcenters,Rradii,'EdgeColor','b');
                 %viscircles(Lcenters,Lradii,'EdgeColor','b');
             end
         end
     end
 end
 %--------�ƾڲֿn-------
 WARMINGING=[WARMING;WARMINGING];%ĵ�i���p���{
 buffer=[Diss;buffer];%�P�_���Y��Jbuffer
 B=[E;B];%�[��bboxes���{
 %-----------------------
 
%########### �O�����H�ybboxes ###############

     
 Face_center=[center(E) ; Face_center];

 
 %%%%% ĵ�� %%%%
work=0;
warm_count=0;
for work=1:page
    if warm_sec(work,1)==1
        warm_count = warm_count+1;
    end
end

if warm_count >=distr
    distime=distime+1;
else
    distime=0;
end

if distime > 15 %page=5 �@���i �ֿndistime15�i=3��
    T=insertText(img,[0 0],['WARMING' WARMING],'FontSize',26,'BoxColor',...
   'red','BoxOpacity',0.4,'TextColor','white');
    imshow(T);

elseif distime <= 15
    T=insertText(img,[0 0],['SAFE' WARMING],'FontSize',26,'BoxColor',...
   'green','BoxOpacity',0.4,'TextColor','white');
    imshow(T);
else
    imshow(img);
end

end
 

 stop(vid)
 flushdata(vid);
 delete(vid);