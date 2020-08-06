function varargout = team6_caijie(varargin)
% TEAM6_CAIJIE MATLAB code for team6_caijie.fig
%      TEAM6_CAIJIE, by itself, creates a new TEAM6_CAIJIE or raises the existing
%      singleton*.
%
%      H = TEAM6_CAIJIE returns the handle to a new TEAM6_CAIJIE or the handle to
%      the existing singleton*.
%
%      TEAM6_CAIJIE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TEAM6_CAIJIE.M with the given input arguments.
%
%      TEAM6_CAIJIE('Property','Value',...) creates a new TEAM6_CAIJIE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before team6_caijie_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to team6_caijie_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help team6_caijie

% Last Modified by GUIDE v2.5 04-Jan-2020 23:47:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @team6_caijie_OpeningFcn, ...
                   'gui_OutputFcn',  @team6_caijie_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before team6_caijie is made visible.
function team6_caijie_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to team6_caijie (see VARARGIN)

% Choose default command line output for team6_caijie
handles.output = hObject;
axes(handles.axes1);
axis off;%關閉坐標軸


vid = videoinput('winvideo',3,'YUY2_640x480'); %建立video input object  'YUY2_640x480'  'MJPG_1024x576'
set(vid,'TriggerRepeat',Inf); % 設定video input物件參數
vid.ReturnedColorSpace='grayscale';

faceDetector = vision.CascadeObjectDetector;
eyeDetector = vision.CascadeObjectDetector('EyePairBig');
ReyeDetector = vision.CascadeObjectDetector('RightEye');
LeyeDetector = vision.CascadeObjectDetector('LeftEye');


handles.vid = vid;
handles.faceDetector = faceDetector;
handles.eyeDetector = eyeDetector;
handles.ReyeDetector = ReyeDetector;
handles.LeyeDetector = LeyeDetector;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes team6_caijie wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = team6_caijie_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in CLOSE.
function CLOSE_Callback(hObject, eventdata, handles)
% hObject    handle to CLOSE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close(gcbf);%gcbf=get callback figure


% --- Executes on selection change in FrameGrabInterval_Menu.
function FrameGrabInterval_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to FrameGrabInterval_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns FrameGrabInterval_Menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from FrameGrabInterval_Menu
contents = cellstr(get(hObject,'String'));
FGI=contents(get(hObject,'Value'));

guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function FrameGrabInterval_Menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FrameGrabInterval_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in START.
function START_Callback(hObject, eventdata, handles)
% hObject    handle to START (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.warningtxt,'String',' ','BackgroundColor',[.94 .94 .94]);
set(handles.warntxt,'String',' ','BackgroundColor',[.94 .94 .94]);
vid = handles.vid;
content=cellstr(get(handles.FrameGrabInterval_Menu,'String'));
FGI=content(get(handles.FrameGrabInterval_Menu,'Value'));
if strcmp(FGI,'FrameGrabInterval')
    FGI = 3;
else
    FGI = str2double(FGI);
end
vid.FrameGrabInterval = FGI; %設定截取時間間距

%--------------------------------------------------------------------------

faceDetector = handles.faceDetector;
eyeDetector = handles.eyeDetector;
ReyeDetector= handles.ReyeDetector;
LeyeDetector= handles.LeyeDetector;

faceDetector.MinSize = [get(handles.FaceMinSize_slider,'Value') get(handles.FaceMinSize_slider,'Value')];
faceDetector.MergeThreshold=get(handles.FaceMergeThreshold_slider,'Value');
eyeDetector.MergeThreshold=get(handles.eyeMergeThreshold_slider,'Value');
ReyeDetector.MinSize = [get(handles.ReyeMinSize_slider,'Value') get(handles.ReyeMinSize_slider,'Value')];
ReyeDetector.MergeThreshold=get(handles.ReyeMergeThreshold_slider,'Value');
LeyeDetector.MinSize = [get(handles.LeyeMinSize_slider,'Value') get(handles.LeyeMinSize_slider,'Value')];
LeyeDetector.MergeThreshold=get(handles.LeyeMergeThreshold_slider,'Value');

%--------------------------------------------------------------------------
i=0;
nF=get(handles.nF_slider,'Value');
B=[];
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
distr=page*0.8;
warm_count=0;
distime=zeros(page+1,1);
Sensitivity=get(handles.Sensitivity_slider,'Value');
EdgeThreshold=get(handles.EdgeThreshold_slider,'Value');
start(vid)%開始截取frame

while(i>-1) 
    
 i=i+1;
 img=getdata(vid,1,'uint8');
 imshow(img);
 bboxes = faceDetector(img);
 %IFace = insertObjectAnnotation(img,'rectangle',bboxes,'Face');
 
%!!!!!!!!!!偵測不到人臉
 if isempty(bboxes)
     warm_sec=[warm_sec;1];
     warm_sec=warm_sec(2:page+1);
     WARMING=['NoFace '];
     E = zeros(1,4);
    %bboxes=zeros(1,4);
     %imshow(img);
      if i>=nF
        u=1;
          while Face_center(u,:)==0  %略過沒抓到臉的，回退
                u=u+1; 
          end
        D = Face_center(u:nF+u-1,:);%取 1~10筆資料做運算
     
        m=LS(nF,D); %最小平方法求斜率
        %mm=[m;mm];%觀察斜率歷程
        Diss=turn(m,nF,D);
        set(handles.distractionTxt,'String',Diss);
      end  

 else
     Diss='F';
     set(handles.distractionTxt,'String',Diss);
     E = [bboxes];
     bigface=img(fix(bboxes(1,2)):fix(bboxes(1,2)+bboxes(1,4)),fix(bboxes(1,1)):fix(bboxes(1,1)+bboxes(1,3)));
     bboxes_eye = eyeDetector(bigface);
          
%!!!!!!!!!!偵測不到大框
     if isempty(bboxes_eye)
         warm_sec=[warm_sec;1];
         warm_sec=warm_sec(2:page+1);
         WARMING=['Eyesdis'];
         bboxes_eye=zeros(1,4);
         %imshow(IFace);

     else
         bboxes_eyebig=0.2;
         bboxes_eye=[bboxes_eye(1,1)+bboxes(1,1) bboxes_eye(1,2)+bboxes(1,2) bboxes_eye(1,3) bboxes_eye(1,4)];
         [ex,ey,ew,eh]=bigger(bboxes_eyebig, bboxes_eye);
         bboxes_eye=[ex,ey,ew,eh];
%         IEyes= insertObjectAnnotation(IFace,'rectangle',bboxes_eye,'EYES');
         %%%%%%%%%左眼右眼框框
         Rbigeye=img(fix(bboxes_eye(1,2)) : fix(bboxes_eye(1,2)+bboxes_eye(1,4)) , fix(bboxes_eye(1,1)+bboxes_eye(1,3)/2) : fix(bboxes_eye(1,1)+bboxes_eye(1,3)));
         Lbigeye=img(fix(bboxes_eye(1,2)) : fix(bboxes_eye(1,2)+bboxes_eye(1,4)) , fix(bboxes_eye(1,1)) : fix(bboxes_eye(1,1)+bboxes_eye(1,3)/2));
         bboxes_Reye = ReyeDetector(Rbigeye);
         bboxes_Leye = LeyeDetector(Lbigeye);
         
%!!!!!!!!!!偵測不到雙眼
         if isempty(bboxes_Reye) || isempty(bboxes_Leye)
             warm_sec=[warm_sec;1];
             warm_sec=warm_sec(2:page+1);
             WARMING=['Eyesdis'];
             %imshow(IEyes);

         else
             %整理變數
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
             
             %%% 等比例放大 %%%             
             big=0.5; 
             [rx, ry, rw, rh]=bigger(big,bboxes_Reye);
             [lx, ly, lw, lh]=bigger(big,bboxes_Leye);
             eyes=[rx ry rw rh ; lx ly lw lh];
             %%%            %%%
           
             %Eyes= insertObjectAnnotation(IEyes,'rectangle',eyes,{'REYE' 'LEYE'});
             
             %找瞳孔
             rmin=fix(rh/5);
             rmax=fix(rh/3);
 
             Reye=img(fix(ry):fix(ry+rh),fix(rx):fix(rx+rw));%擷取雙眼框範圍
             Leye=img(fix(ly):fix(ly+lh),fix(lx):fix(lx+lw));
 

             [Rcenters, Rradii] = imfindcircles(Reye,[rmin,rmax],'ObjectPolarity',...
                 'dark','Sensitivity',Sensitivity,'EdgeThreshold',EdgeThreshold);%,'Sensitivity',1,'EdgeThreshold',0.3
             [Lcenters, Lradii] = imfindcircles(Leye,[rmin,rmax],'ObjectPolarity',...
                 'dark','Sensitivity',Sensitivity,'EdgeThreshold',EdgeThreshold);%,'Sensitivity',1,'EdgeThreshold',0.3

%!!!!!!!!!!偵測不到瞳孔
             if isempty(Rradii) || isempty(Lradii)
                 warm_sec=[warm_sec;1];
                 warm_sec=warm_sec(2:page+1);
                 WARMING=['Eyesdis'];
                 %imshow(Eyes);
             else
                 Rradii=Rradii(1,1);
                 Lradii=Lradii(1,1);
                 Rcenters=[Rcenters(1,1)+rx,Rcenters(1,2)+ry];%須加回原座標
                 Lcenters=[Lcenters(1,1)+lx,Lcenters(1,2)+ly];
                 
                 
                 %------- 眼球偏移 ---------
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
                     %WARMING=['SAFE   '];
                 end
                 %------- 眼球偏移 ---------end
                 
                
                 %viscircles(Rcenters,Rradii,'EdgeColor','b');
                 %viscircles(Lcenters,Lradii,'EdgeColor','b');
             end
         end
     end
 end
 %--------數據累積-------
 %WARMINGING=[WARMING;WARMINGING];%警告狀況歷程
 %buffer=[Diss;buffer];%判斷轉頭放入buffer
 %B=[E;B];%觀察bboxes歷程
 %-----------------------
 
%########### 記錄完人臉bboxes ###############

 Face_center=[center(E) ; Face_center];

 
 %%%%% 警報 %%%%
work=0;
warm_count=0;
for work=1:page
    if warm_sec(work,1)==1
        warm_count = warm_count+1;
    end
end

if warm_count >=distr
     distime=[distime;1];
     distime=distime(2:page+2);
else
    distime=[distime;0];
    distime=distime(2:page+2);
end

if distime(1,1)==1
    work=2;
    distime_count=0;
    for work=2:page+1
        if distime(work,1)==1
            distime_count = distime_count+1;
        end
    end
    
    if distime_count >= distr
        set(handles.warntxt,'String','WARNING','backgroundcolor','r');
        set(handles.warningtxt,'String',WARMING,'backgroundcolor','b');
        %sound(y, fs);
    else
        set(handles.warntxt,'String',' ','BackgroundColor',[.94 .94 .94]);
        set(handles.warningtxt,'String',' ','BackgroundColor',[.94 .94 .94]);
    end
else
     distime_count=0;
    set(handles.warntxt,'String',' ','BackgroundColor',[.94 .94 .94]);
    set(handles.warningtxt,'String',' ','BackgroundColor',[.94 .94 .94]);
end

end
guidata(hObject, handles);

% --- Executes on button press in STOP.
function STOP_Callback(hObject, eventdata, handles)
% hObject    handle to STOP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
vid = handles.vid;

stop(vid);
clear vid;


% --- Executes on LeyeMinSize_slider movement.
function nF_slider_Callback(hObject, eventdata, handles)
% hObject    handle to nF_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of LeyeMinSize_slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of LeyeMinSize_slider
txt=get(handles.nF_slider,'Value');
set(handles.nF_slidertxt,'String',num2str(round(txt)));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function nF_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nF_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: LeyeMinSize_slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on LeyeMinSize_slider movement.
function FaceMinSize_slider_Callback(hObject, eventdata, handles)
% hObject    handle to FaceMinSize_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of LeyeMinSize_slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of LeyeMinSize_slider
txt=get(handles.FaceMinSize_slider,'Value');
set(handles.FaceMinSize_slidertxt,'String',num2str(round(txt)));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function FaceMinSize_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FaceMinSize_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: LeyeMinSize_slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on LeyeMinSize_slider movement.
function FaceMergeThreshold_slider_Callback(hObject, eventdata, handles)
% hObject    handle to FaceMergeThreshold_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of LeyeMinSize_slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of LeyeMinSize_slider
txt=get(handles.FaceMergeThreshold_slider,'Value');
set(handles.FaceMergeThreshold_slidertxt,'String',num2str(round(txt)));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function FaceMergeThreshold_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FaceMergeThreshold_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: LeyeMinSize_slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function eyeMergeThreshold_slider_Callback(hObject, eventdata, handles)
% hObject    handle to eyeMergeThreshold_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of LeyeMinSize_slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of LeyeMinSize_slider
txt=get(handles.eyeMergeThreshold_slider,'Value');
set(handles.eyeMergeThreshold_slidertxt,'String',num2str(round(txt)));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function eyeMergeThreshold_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eyeMergeThreshold_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: LeyeMinSize_slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



% --- Executes on LeyeMinSize_slider movement.
function ReyeMergeThreshold_slider_Callback(hObject, eventdata, handles)
% hObject    handle to ReyeMergeThreshold_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of LeyeMinSize_slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of LeyeMinSize_slider
txt=get(handles.ReyeMergeThreshold_slider,'Value');
set(handles.ReyeMergeThreshold_slidertxt,'String',num2str(round(txt)));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function ReyeMergeThreshold_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ReyeMergeThreshold_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: LeyeMinSize_slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on LeyeMinSize_slider movement.
function LeyeMergeThreshold_slider_Callback(hObject, eventdata, handles)
% hObject    handle to LeyeMergeThreshold_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of LeyeMinSize_slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of LeyeMinSize_slider
txt=get(handles.LeyeMergeThreshold_slider,'Value');
set(handles.LeyeMergeThreshold_slidertxt,'String',num2str(round(txt)));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function LeyeMergeThreshold_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LeyeMergeThreshold_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: LeyeMinSize_slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on LeyeMinSize_slider movement.
function ReyeMinSize_slider_Callback(hObject, eventdata, handles)
% hObject    handle to ReyeMinSize_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of LeyeMinSize_slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of LeyeMinSize_slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of LeyeMinSize_slider
txt=get(handles.ReyeMinSize_slider,'Value');
set(handles.ReyeMinSize_slidertxt,'String',num2str(round(txt)));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function ReyeMinSize_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ReyeMinSize_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: LeyeMinSize_slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on LeyeMinSize_slider movement.
function LeyeMinSize_slider_Callback(hObject, eventdata, handles)
% hObject    handle to LeyeMinSize_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of LeyeMinSize_slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of LeyeMinSize_slider
txt=get(handles.LeyeMinSize_slider,'Value');
set(handles.LeyeMinSize_slidertxt,'String',num2str(round(txt)));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function LeyeMinSize_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LeyeMinSize_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: LeyeMinSize_slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function Sensitivity_slider_Callback(hObject, eventdata, handles)
% hObject    handle to Sensitivity_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
txt=get(handles.Sensitivity_slider,'Value');
set(handles.Sensitivitytxt,'String',num2str(round(txt,3)));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Sensitivity_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Sensitivity_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function EdgeThreshold_slider_Callback(hObject, eventdata, handles)
% hObject    handle to EdgeThreshold_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
txt=get(handles.EdgeThreshold_slider,'Value');
set(handles.EdgeThresholdtxt,'String',num2str(round(txt,2)));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function EdgeThreshold_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EdgeThreshold_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
