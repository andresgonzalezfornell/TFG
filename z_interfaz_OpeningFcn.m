%% Acciones que tienen lugar al abrir la interfaz

% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to overdrive (see VARARGIN)

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

% Rango de parametros
if isfield(handles,'limites')
    for i = 1:length(handles.limites)
        switch i
            case 1
                set(handles.par_1,'Min',handles.limites(i).Min,'Max',handles.limites(i).Max)
            case 2
                set(handles.par_2,'Min',handles.limites(i).Min,'Max',handles.limites(i).Max)
            case 3
                set(handles.par_3,'Min',handles.limites(i).Min,'Max',handles.limites(i).Max)
            case 4
                set(handles.par_4,'Min',handles.limites(i).Min,'Max',handles.limites(i).Max)
            case 5
                set(handles.par_5,'Min',handles.limites(i).Min,'Max',handles.limites(i).Max)
            case 6
                set(handles.par_6,'Min',handles.limites(i).Min,'Max',handles.limites(i).Max)
        end
    end
end

% Reproductor de salida
set(handles.pause_salida,'Enable','off')
set(handles.play_salida,'Enable','off')
set(handles.stop_salida,'Enable','off')

% Longitud de oscilador de entrada
set(handles.entrada_length,'String',2)

% LFO
handles.LFO_0.checkbox = 0;
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

% Modulador
handles.modulador(1).checkbox = 0;
handles.modulador(2).checkbox = 0;
handles.modulador(3).checkbox = 0;

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

% Espera a la aplicacion del filtro para devolver la salida de la interfaz
uiwait