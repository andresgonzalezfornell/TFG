%% Acciones que tienen lugar al abrir la interfaz

% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to overdrive (see VARARGIN)

% Choose default command line output for overdrive
handles.output = hObject;
handles.fs = 44100;
handles.path = strcat(pwd,'/Audios');

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

% Limpieza de variables
if isfield(handles,'y')
    clear handles.y
end

% LFO
handles.LFO_1.checkbox = 0;
handles.LFO_2.checkbox = 0;
handles.LFO_3.checkbox = 0;
handles.LFO_4.checkbox = 0;
handles.LFO_5.checkbox = 0;
handles.LFO_6.checkbox = 0;
set(handles.par_1_LFO,'Enable','off')
set(handles.par_2_LFO,'Enable','off')
set(handles.par_3_LFO,'Enable','off')
set(handles.par_4_LFO,'Enable','off')
set(handles.par_5_LFO,'Enable','off')
set(handles.par_6_LFO,'Enable','off')

% Cargador de ficheros de entrada
dir_struct = dir(handles.path);
[sorted_names,sorted_index] = sortrows({dir_struct.name}');
handles.file_names = sorted_names;
handles.is_dir = [dir_struct.isdir];
handles.sorted_index = sorted_index;
guidata(handles.figure1,handles)
set(handles.entrada_lista,'String',handles.file_names,...
    'Value',1)
set(handles.directorio,'String',handles.path)

% Update handles structure
guidata(hObject, handles);

% Espera a la aplicación del filtro para devolver la salida de la interfaz
uiwait