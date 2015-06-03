function varargout = index(varargin)
% Libreria de efectos digitales de audio con procesamiento a tiempo no real.
%
%   Incluye una interfaz de usuario sencilla y autoexplicativa, y ofrece un control libre de los
%   parametros del efecto, eleccion y visualizacion del audio de entrada,reproducción y visualizacion
%   del audio de salida, y representacion caracteristica del procesamiento que se esta realizando.
%
% Version v1.0 (01 de julio de 2015)
%   En esta version se encuentran disponibles los siguiente efectos:
%       autowah
%       delay
%       distortion
%       overdrive
%       panning
%       phaser
%
% Desarrollad por Andres Gonzalez Fornell bajo el Departamento de Señales y Sistemas de Radiocomunicacion
% andresgonzalezfornell@gmail.com
% Escuela Tecnica Superior de Ingenieros de Telecomunicacion
% Universidad Politecnica de Madrid


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @index_OpeningFcn, ...
                   'gui_OutputFcn',  @index_OutputFcn, ...
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


% --- Executes just before index is made visible.
function index_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to index (see VARARGIN)
% Choose default command line output for index
handles.output = hObject;
% Logos
ssr_im = imread('Images/ssr.jpg');
axes(handles.ssr);
imshow(ssr_im);
etsit_im = imread('Images/etsit.jpg');
axes(handles.etsit);
imshow(etsit_im);
upm_im = imread('Images/upm.jpg');
axes(handles.upm);
imshow(upm_im);
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes index wait for user response (see UIRESUME)
% uiwait(handles.index);


% --- Outputs from this function are returned to the command line.
function varargout = index_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%% Llamada a efectos
% --- Executes on button press in autowah.
function autowah_Callback(hObject, eventdata, handles)
% hObject    handle to autowah (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close
autowah


% --- Executes on button press in delay.
function delay_Callback(hObject, eventdata, handles)
% hObject    handle to delay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close
delay


% --- Executes on button press in distortion.
function distortion_Callback(hObject, eventdata, handles)
% hObject    handle to distortion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close
distortion


% --- Executes on button press in overdrive.
function overdrive_Callback(hObject, eventdata, handles)
% hObject    handle to overdrive (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close
overdrive


% --- Executes on button press in panning.
function panning_Callback(hObject, eventdata, handles)
% hObject    handle to panning (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close
panning


% --- Executes on button press in phaser.
function phaser_Callback(hObject, eventdata, handles)
% hObject    handle to phaser (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close
phaser