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

% Last Modified by GUIDE v2.5 03-Jun-2015 12:30:47

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
handles.fs = varargin{3};
% Inicializacion de parametros
handles.delta = (handles.limites.Max-handles.limites.Min)/2;
handles.LFO.amplitud_Min = 0;
handles.LFO.amplitud_Max = handles.delta;
handles.LFO.amplitud_Max;
if handles.par == 0
    handles.LFO.frecuencia = 440;
    handles.LFO.frecuencia_Min = 20;
    handles.LFO.frecuencia_Max = 20000;
    handles.LFO.offset = 0;
    set(handles.title,'String','Generador de audio mediante el LFO')
    set(handles.offset,'Enable','off')
    set(handles.offset_value,'Enable','off')
    set(handles.externa,'Enable','off')
else
    handles.LFO.frecuencia = 2;
    handles.LFO.frecuencia_Min = 0.1;
    handles.LFO.frecuencia_Max = 10;
    set(handles.title,'String',strcat('Aplicar LFO a parametro ',num2str(handles.par)))
    handles.LFO.offset = handles.delta+handles.limites.Min;
    set(handles.offset,'Enable','on','Value',handles.LFO.offset,'Min',handles.limites.Min+handles.delta/2,'Max',handles.limites.Max-handles.delta/2)
    set(handles.offset_value,'Enable','on','String',handles.LFO.offset)
end
set(handles.tipo_panel,'SelectedObject',handles.sinusoidal)
set(handles.frecuencia,'Value',handles.LFO.frecuencia,'Min',handles.LFO.frecuencia_Min,'Max',handles.LFO.frecuencia_Max)
set(handles.frecuencia_value,'String',handles.LFO.frecuencia)
handles.LFO.amplitud = handles.delta/2;
set(handles.amplitud,'Value',handles.LFO.amplitud,'Min',handles.LFO.amplitud_Min,'Max',handles.LFO.amplitud_Max)
set(handles.amplitud_value,'String',handles.LFO.amplitud)
handles.LFO.submit = 0;
% Modulador
handles.LFO.modulador(1).checkbox = 0;      % FM
handles.LFO.modulador(2).checkbox = 0;      % AM
% Grafico
xlabel(handles.graf,'Tiempo [s]')
set(handles.graf,'XLim',[0 handles.limites.longitud])
set(handles.graf,'YLim',[handles.limites.Min handles.limites.Max])
z_LFO_graf
% Update handles structure
guidata(hObject, handles);
uiwait
% UIWAIT makes z_LFO_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = z_LFO_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
if ~isfield(handles,'LFO')
    handles.LFO.submit = 0;
end
varargout{1} = handles.LFO;
close()


% --- Executes on button press in submit.
function submit_Callback(hObject, eventdata, handles)
% hObject    handle to submit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tipo = get(handles.tipo_panel,'SelectedObject');
handles.LFO.tipo = tipo.String;
handles.LFO.submit = 1;
% Update handles structure
guidata(hObject, handles);
uiresume


% --- Executes on button press in cancel.
function cancel_Callback(hObject, eventdata, handles)
% hObject    handle to cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume

% --- Executes on slider movement.
function frecuencia_Callback(hObject, eventdata, handles)
% hObject    handle to frecuencia (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.LFO.frecuencia = get(hObject,'Value');
set(handles.frecuencia_value,'String',handles.LFO.frecuencia)
z_LFO_graf
% Update handles structure
guidata(hObject, handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


function frecuencia_value_Callback(hObject, eventdata, handles)
% hObject    handle to frecuencia_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if str2double(get(hObject,'String'))>=handles.LFO.frecuencia_Min & str2double(get(hObject,'String'))<=handles.LFO.frecuencia_Max
    handles.LFO.frecuencia = str2double(get(hObject,'String'));
    set(handles.frecuencia,'Value',handles.LFO.frecuencia)
else
    set(handles.frecuencia_value,'String',handles.LFO.frecuencia)
end
z_LFO_graf
% Update handles structure
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of frecuencia_value as text
%        str2double(get(hObject,'String')) returns contents of frecuencia_value as a double


% --- Executes on slider movement.
function amplitud_Callback(hObject, eventdata, handles)
% hObject    handle to amplitud (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.LFO.amplitud = get(hObject,'Value');
set(handles.amplitud_value,'String',handles.LFO.amplitud)
if handles.LFO.amplitud == handles.LFO.amplitud_Max
    set(handles.offset,'Enable','off')
else
    if handles.par ~= 0
        set(handles.offset,'Enable','on')
    end
end
if handles.LFO.offset < (handles.limites.Min+handles.LFO.amplitud)
    handles.LFO.offset = handles.limites.Min+handles.LFO.amplitud;
    set(handles.offset,'Value',handles.LFO.offset)
    set(handles.offset_value,'String',handles.LFO.offset)
elseif handles.LFO.offset > (handles.limites.Max-handles.LFO.amplitud)
    handles.LFO.offset = handles.limites.Max-handles.LFO.amplitud;
    set(handles.offset,'Value',handles.LFO.offset)
    set(handles.offset_value,'String',handles.LFO.offset)
end
set(handles.offset,'Min',handles.limites.Min+handles.LFO.amplitud,'Max',handles.limites.Max-handles.LFO.amplitud)
z_LFO_graf
% Update handles structure
guidata(hObject, handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


function amplitud_value_Callback(hObject, eventdata, handles)
% hObject    handle to amplitud_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if str2double(get(hObject,'String'))>=handles.LFO.amplitud_Min & str2double(get(hObject,'String'))<=handles.LFO.amplitud_Max
    handles.LFO.amplitud = str2double(get(hObject,'String'));
    set(handles.amplitud,'Value',handles.LFO.amplitud)
    if handles.LFO.amplitud == handles.LFO.amplitud_Max
        set(handles.offset,'Enable','off')
    else
        if handles.par ~= 0
            set(handles.offset,'Enable','on')
        end
    end
    if handles.LFO.offset < (handles.limites.Min+handles.LFO.amplitud)
        handles.LFO.offset = handles.limites.Min+handles.LFO.amplitud;
        set(handles.offset,'Value',handles.LFO.offset)
        set(handles.offset_value,'String',handles.LFO.offset)
    elseif handles.LFO.offset > (handles.limites.Max-handles.LFO.amplitud)
        handles.LFO.offset = handles.limites.Max-handles.LFO.amplitud;
        set(handles.offset,'Value',handles.LFO.offset)
        set(handles.offset_value,'String',handles.LFO.offset)
    end
    set(handles.offset,'Min',handles.limites.Min+handles.LFO.amplitud,'Max',handles.limites.Max-handles.LFO.amplitud)
else
    set(handles.amplitud_value,'String',handles.LFO.amplitud)
end
z_LFO_graf
% Update handles structure
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of amplitud_value as text
%        str2double(get(hObject,'String')) returns contents of amplitud_value as a double


% --- Executes on slider movement.
function offset_Callback(hObject, eventdata, handles)
% hObject    handle to offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.LFO.offset = get(hObject,'Value');
set(handles.offset_value,'String',handles.LFO.offset)
z_LFO_graf
% Update handles structure
guidata(hObject, handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


function offset_value_Callback(hObject, eventdata, handles)
% hObject    handle to offset_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if str2double(get(hObject,'String'))>=(handles.limites.Min+handles.LFO.amplitud) & str2double(get(hObject,'String'))<=(handles.limites.Max-handles.LFO.amplitud)
    handles.LFO.offset = str2double(get(hObject,'String'));
    set(handles.offset,'Value',handles.LFO.offset)
else
    set(handles.offset_value,'String',handles.LFO.offset)
end
z_LFO_graf
% Update handles structure
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of offset_value as text
%        str2double(get(hObject,'String')) returns contents of offset_value as a double


% --- Executes during object creation, after setting all properties.
function frecuencia_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frecuencia (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function frecuencia_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frecuencia_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function amplitud_CreateFcn(hObject, eventdata, handles)
% hObject    handle to amplitud (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function amplitud_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to amplitud_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function offset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function offset_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to offset_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in sinusoidal.
function sinusoidal_Callback(hObject, eventdata, handles)
% hObject    handle to sinusoidal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
z_LFO_graf
% Update handles structure
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of triangular


% --- Executes on button press in triangular.
function triangular_Callback(hObject, eventdata, handles)
% hObject    handle to triangular (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
z_LFO_graf
% Update handles structure
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of triangular


% --- Executes on button press in sierra_asc.
function sierra_asc_Callback(hObject, eventdata, handles)
% hObject    handle to sierra_asc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
z_LFO_graf
% Update handles structure
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of sierra_asc


% --- Executes on button press in sierra_desc.
function sierra_desc_Callback(hObject, eventdata, handles)
% hObject    handle to sierra_desc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
z_LFO_graf
% Update handles structure
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of sierra_desc


% --- Executes on button press in cuadrada.
function cuadrada_Callback(hObject, eventdata, handles)
% hObject    handle to cuadrada (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
z_LFO_graf
% Update handles structure
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of cuadrada


% --- Executes on button press in ruido.
function ruido_Callback(hObject, eventdata, handles)
% hObject    handle to ruido (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
z_LFO_graf
% Update handles structure
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of ruido


% --- Executes on button press in externa.
function externa_Callback(hObject, eventdata, handles)
% hObject    handle to cuadrada (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
z_LFO_graf
% Update handles structure
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of externa


% --- Executes on button press in frecuencia_LFO.
function frecuencia_LFO_Callback(hObject, eventdata, handles)
% hObject    handle to frecuencia_LFO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = z_modulador(handles,1);
z_LFO_graf
% Update handles structure
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of frecuencia_LFO


% --- Executes on button press in amplitud_LFO.
function amplitud_LFO_Callback(hObject, eventdata, handles)
% hObject    handle to amplitud_LFO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = z_modulador(handles,2);
z_LFO_graf
% Update handles structure
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of amplitud_LFO