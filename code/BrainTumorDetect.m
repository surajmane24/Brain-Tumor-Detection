function varargout = BrainTumorDetect(varargin)
% BRAINTUMORDETECT MATLAB code for BrainTumorDetect.fig
%      BRAINTUMORDETECT, by itself, creates a new BRAINTUMORDETECT or raises the existing
%      singleton*.
%
%      H = BRAINTUMORDETECT returns the handle to a new BRAINTUMORDETECT or the handle to
%      the existing singleton*.
%
%      BRAINTUMORDETECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BRAINTUMORDETECT.M with the given input arguments.
%
%      BRAINTUMORDETECT('Property','Value',...) creates a new BRAINTUMORDETECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BrainTumorDetect_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BrainTumorDetect_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BrainTumorDetect

% Last Modified by GUIDE v2.5 24-Mar-2022 12:58:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BrainTumorDetect_OpeningFcn, ...
                   'gui_OutputFcn',  @BrainTumorDetect_OutputFcn, ...
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


% --- Executes just before BrainTumorDetect is made visible.
function BrainTumorDetect_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BrainTumorDetect (see VARARGIN)

% Choose default command line output for BrainTumorDetect
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes BrainTumorDetect wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = BrainTumorDetect_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global img1 img2

[path, nofile] = imgetfile();

if nofile 
    msbox(sprintf('Image not fund !!!'),'Error','Warning');
    return
end

img1 = imread(path);
img1 = im2double(img1);
img2 = img1;

axes(handles.axes1);
imshow(img1)

title('\fontsize{20}\color[rgb]{0.996, 0.529, 0.0} Brain MRI')


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global img1
axes(handles.axes2);
bw = im2bw(img1,0.7);
label = bwlabel(bw);

stats = regionprops(logical(label), 'Solidity', 'Area');
density = [stats.Solidity];
area = [stats.Area];
high_dense_area = density > 0.5;
max_area = max(area(high_dense_area));
tumor_label = find(area == max_area);
tumor = ismember(label, tumor_label);

se = strel('square', 5);
tumor = imdilate(tumor, se);

Bound = bwboundaries(tumor, 'noholes');

imshow(img1);
hold on

for i = 1:length(Bound)
    plot(Bound{i} (:, 2), Bound{i} (:, 1), 'y', 'linewidth', 1.75);
end

title('\fontsize{20}\color[rgb]{0.996, 0.592, 0.0} Tumor Detcted');

hold off
axes(handles.axes);
