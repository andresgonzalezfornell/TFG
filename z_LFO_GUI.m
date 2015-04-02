function varargout = z_LFO_GUI(varargin)
% Z_LFO_GUI MATLAB code for z_LFO_GUI.fig
%      Z_LFO_GUI, by itself, creates a new Z_LFO_GUI or raises the existing
%      singleton*.
%
%      H = Z_LFO_GUI returns the handle to a new Z_LFO_GUI or the handle to
%      the existing singleton*.
%
%      Z_LFO_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in Z_LFO_GUI.M with the given input arguments.
%
%      Z_LFO_GUI('Property','Value',...) creates a new Z_LFO_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before z_LFO_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to z_LFO_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help z_LFO_GUI

% Last Modified by GUIDE v2.5 02-Apr-2015 14:24:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @z_LFO_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @z_LFO_GUI_OutputFcn, ...
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


% --- Executes just before z_LFO_GUI is made visible.
function z_LFO_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to z_LFO_GUI (see VARARGIN)
handles.par = varargin{1};
handles.limites = varargin{2};
set(handles.title,'String',strcat('Aplicar LFO al parámetro ',num2str(handles.par)));
handles.output = 1;
handles.LFO = struct('tipo','triangular','frecuencia',100,'central',0.5,'amplitud',0.1);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes z_LFO_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = z_LFO_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
varargout{2} = handles.LFO;


% --- Executes on button press in submit.
function submit_Callback(hObject, eventdata, handles)
% hObject    handle to submit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
