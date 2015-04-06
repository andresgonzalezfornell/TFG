function varargout = panning(varargin)
% Efecto de PANNING
% 
%      Si desea pasar la salida del efecto a su workspace escriba:
%
%                   y = panning;
%
%      La variable devuelta "y" se corresponde con un array
%      multidimensional formado por las siguientes señales
%       y(:,1) señal canal L
%       y(:,2) señal canal R
%       y(:,3) espectro de señal canal L
%       y(:,4) espectro de señal canal R
%       y(:,5) espectro de señal media entre ambos canales
%      Nota: puede cambiar el nombre de la variable "y" por la que desee.


%% Manual de uso de plantilla
%   Copiar template.m y template.fig modificando template por el nombre del efecto (panning) y editar el panning.m
%   Buscar y reemplazar:
%       panning        por nombre del efecto siguiendo el formato (ej.: overdrive)
%       Panning        por nombre del efecto siguiendo el formato (ej.: Overdrive)
%       PANNING        por nombre del efecto siguiendo el formato (ej.: OVERDRIVE)
%       <Descripción>   por la descripción del efecto
%   Implementar el efecto en la función aplicar_callback.
%   Inicializar los parámetros siguiendo el formato de ejemplo en la función panning_OpeningFcn
%   Implementar los parámetros en las funciones par_<#>_Callback
%   Modificar en el archivo panning.fig los callbacks de los botones

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @panning_OpeningFcn, ...
                   'gui_OutputFcn',  @panning_OutputFcn, ...
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


%% EFECTO
% --- Executes on button press in aplicar.
function aplicar_Callback(hObject, eventdata, handles)
% hObject    handle to aplicar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Limpieza de salida
clear handles.y

% Panning
g = [1 1];
if handles.LFO_1.checkbox                               % Con LFO
    res.LFO = 10;
    res.y = res.LFO*floor(length(handles.x(:,1))/handles.LFO_N);
    for n = 1:res.LFO:handles.LFO_N
        az_virtual = handles.LFO_1.x(n);
        k = (tand(handles.az_altavoz)-tand(az_virtual)) / (tand(handles.az_altavoz)+tand(az_virtual));
        if k>1
            g((n-1)*res.y/res.LFO+1:n*res.y/res.LFO,1) = 1;
            g((n-1)*res.y/res.LFO+1:n*res.y/res.LFO,2) = 1/k;
        else
            g((n-1)*res.y/res.LFO+1:n*res.y/res.LFO,1) = k;
            g((n-1)*res.y/res.LFO+1:n*res.y/res.LFO,2) = 1;
        end
    end
    if k>1
        g(n*res.y/res.LFO:length(handles.x(:,1)),1) = 1;
        g(n*res.y/res.LFO:length(handles.x(:,1)),2) = 1/k;
    else
        g(n*res.y/res.LFO:length(handles.x(:,1)),1) = k;
        g(n*res.y/res.LFO:length(handles.x(:,1)),2) = 1;
    end
else                                                    % Sin LFO
    k = (tand(handles.az_altavoz)-tand(handles.az_virtual)) / (tand(handles.az_altavoz)+tand(handles.az_virtual));
    if k>1
        g(2) = 1/k;
    else
        g(1) = k;
    end
end
handles.y = g.*handles.x;

z_interfaz_salida


%% Parámetros
% --- Executes on slider movement.
function par_1_Callback(hObject, eventdata, handles)
% hObject    handle to par_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.az_virtual = get(hObject,'Value');
set(handles.par_1_value,'String',handles.az_virtual)
suma_fuente = [15*sind(handles.az_virtual) 7.5*cosd(handles.az_virtual) 0 0];
set(handles.fuente,'Position',suma_fuente+handles.p_0);
% Update handles structure
guidata(hObject, handles);


function par_1_value_Callback(hObject, eventdata, handles)
% hObject    handle to par_1_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if abs(str2double(get(hObject,'String')))<=handles.az_altavoz
    handles.az_virtual = str2double(get(hObject,'String'));
    set(handles.par_1,'Value',handles.az_virtual)
    set(handles.par_1_value,'String',handles.az_virtual)
    suma_fuente = [15*sind(handles.az_virtual) 7.5*cosd(handles.az_virtual) 0 0];
    set(handles.fuente,'Position',suma_fuente+handles.p_0);
else
    set(handles.par_1_value,'String',handles.az_virtual)
end
% Update handles structure
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of par_1_value as text
%        str2double(get(hObject,'String')) returns contents of par_1_value as a double


% --- Executes on slider movement.
function par_2_Callback(hObject, eventdata, handles)
% hObject    handle to par_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.az_altavoz = get(hObject,'Value');
set(handles.par_2_value,'String',handles.az_altavoz)
suma_L = [15*sind(handles.az_altavoz) 7.5*cosd(handles.az_altavoz) 0 0];
suma_R = [15*sind(-handles.az_altavoz) 7.5*cosd(handles.az_altavoz) 0 0];
set(handles.altavoz_L,'Position',suma_L+handles.p_0);
set(handles.altavoz_R,'Position',suma_R+handles.p_0);
if abs(handles.az_virtual) > handles.az_altavoz
    handles.az_virtual = sign(handles.az_virtual)*handles.az_altavoz;
    set(handles.par_1,'Value',handles.az_virtual)
    set(handles.par_1_value,'String',handles.az_virtual)
    suma_fuente = [15*sind(handles.az_virtual) 7.5*cosd(handles.az_virtual) 0 0];
    set(handles.fuente,'Position',suma_fuente+handles.p_0);
end
set(handles.par_1,'Min',-handles.az_altavoz,'Max',handles.az_altavoz)
% Update handles structure
guidata(hObject, handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


function par_2_value_Callback(hObject, eventdata, handles)
% hObject    handle to par_2_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if str2double(get(hObject,'String'))>=1 & str2double(get(hObject,'String'))<=89
    handles.az_altavoz = str2double(get(hObject,'String'));
    set(handles.par_2,'Value',handles.az_altavoz)
    suma_L = [15*sind(handles.az_altavoz) 7.5*cosd(handles.az_altavoz) 0 0];
    suma_R = [15*sind(-handles.az_altavoz) 7.5*cosd(handles.az_altavoz) 0 0];
    set(handles.altavoz_L,'Position',suma_L+handles.p_0);
    set(handles.altavoz_R,'Position',suma_R+handles.p_0);
    if abs(handles.az_virtual) > handles.az_altavoz
        handles.az_virtual = sign(handles.az_virtual)*handles.az_altavoz;
        set(handles.par_1,'Value',handles.az_virtual)
        set(handles.par_1_value,'String',handles.az_virtual)
        suma_fuente = [15*sind(handles.az_virtual) 7.5*cosd(handles.az_virtual) 0 0];
        set(handles.fuente,'Position',suma_fuente+handles.p_0);
    end
    set(handles.par_1,'Min',-handles.az_altavoz,'Max',handles.az_altavoz)
else
    set(handles.par_2_value,'String',handles.az_altavoz)
end
% Update handles structure
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of par_2_value as text
%        str2double(get(hObject,'String')) returns contents of par_2_value as a double


% --- Executes on slider movement.
function par_3_Callback(hObject, eventdata, handles)
% hObject    handle to par_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

function par_3_value_Callback(hObject, eventdata, handles)
% hObject    handle to par_3_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if str2double(get(hObject,'String'))>=0 & str2double(get(hObject,'String'))<=1
    % Update handles structure
    guidata(hObject, handles);
else
end
% Hints: get(hObject,'String') returns contents of par_3_value as text
%        str2double(get(hObject,'String')) returns contents of par_3_value as a double


% --- Executes on slider movement.
function par_4_Callback(hObject, eventdata, handles)
% hObject    handle to par_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


function par_4_value_Callback(hObject, eventdata, handles)
% hObject    handle to par_4_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if str2double(get(hObject,'String'))>=0 & str2double(get(hObject,'String'))<=1
    % Update handles structure
    guidata(hObject, handles);
else
end
% Hints: get(hObject,'String') returns contents of par_4_value as text
%        str2double(get(hObject,'String')) returns contents of par_4_value as a double


% --- Executes on slider movement.
function par_5_Callback(hObject, eventdata, handles)
% hObject    handle to par_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


function par_5_value_Callback(hObject, eventdata, handles)
% hObject    handle to par_5_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if str2double(get(hObject,'String'))>=0 & str2double(get(hObject,'String'))<=1
    % Update handles structure
    guidata(hObject, handles);
else
end
% Hints: get(hObject,'String') returns contents of par_5_value as text
%        str2double(get(hObject,'String')) returns contents of par_5_value as a double


% --- Executes on slider movement.
function par_6_Callback(hObject, eventdata, handles)
% hObject    handle to par_6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


function par_6_value_Callback(hObject, eventdata, handles)
% hObject    handle to par_6_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if str2double(get(hObject,'String'))>=0 & str2double(get(hObject,'String'))<=1
    % Update handles structure
    guidata(hObject, handles);
else
end
% Hints: get(hObject,'String') returns contents of par_6_value as text
%        str2double(get(hObject,'String')) returns contents of par_6_value as a double


%% Gr�fica del efecto
% --- Executes on button press in graf_open.
function graf_open_Callback(hObject, eventdata, handles)
% hObject    handle to graf_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Controles de interfaz
% --- Executes just before panning is made visible.
function panning_OpeningFcn(hObject, eventdata, handles, varargin)
% Descripci�n del efecto
set(handles.titulo,'String','Panning')
set(handles.des,'String','Produce la ilusión al oyente de una dirección determinada de origen del sonido, siempre y cuando se cuente con al menos dos canales estéreo y dos fuentes separadas suficientemente rodeando al oyente.')
% Inicializaci�n de par�metros
handles.az_virtual = 0;
handles.az_altavoz = 60;
handles.limites(1).Min = -60;
handles.limites(1).Max = 60;
set(handles.par_1,'Visible','on','Value',0,'Min',handles.limites(1).Min,'Max',handles.limites(1).Max)
set(handles.par_1_value,'Visible','on','String',0)
set(handles.par_1_title,'Visible','on','String','Acimut virtual [º]')
set(handles.par_1_LFO,'Visible','on')
set(handles.par_2,'Visible','on','Value',60,'Min',1,'Max',89)
set(handles.par_2_value,'Visible','on','String',60)
set(handles.par_2_title,'Visible','on','String','Acimut de los altavoces [º]')
% Dibujo
oyente_im = imread('Images/oyente.png');
axes(handles.oyente);
imshow(oyente_im);
altavoz_L_im = imread('Images/altavoz_L.png');
axes(handles.altavoz_L);
imshow(altavoz_L_im);
altavoz_R_im = imread('Images/altavoz_R.png');
axes(handles.altavoz_R);
imshow(altavoz_R_im);
fuente_im = imread('Images/fuente.png');
axes(handles.fuente);
imshow(fuente_im);
handles.p_0 = get(handles.oyente,'Position');
suma_L = [15*sind(60) 7.5*cosd(60) 0 0];
suma_R = [15*sind(-60) 7.5*cosd(60) 0 0];
suma_fuente = [15*sind(0) 7.5*cosd(0) 0 0];
set(handles.altavoz_L,'Position',suma_L+handles.p_0);
set(handles.altavoz_R,'Position',suma_R+handles.p_0);
set(handles.fuente,'Position',suma_fuente+handles.p_0);

% Interfaz
z_interfaz_OpeningFcn
% UIWAIT makes panning wait for user response (see UIRESUME)


% --- Executes on selection change in entrada_lista.
function entrada_lista_Callback(hObject, eventdata, handles)
% hObject    handle to entrada_lista (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Interfaz
z_interfaz_entrada_lista_Callback


% Hints: contents = cellstr(get(hObject,'String')) returns entrada_lista contents as cell array
%        contents{get(hObject,'Value')} returns selected item from entrada_lista


% --- Outputs from this function are returned to the command line.
function varargout = panning_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
z_interfaz_OutputFcn


% --- Executes during object creation, after setting all properties.
function entrada_lista_CreateFcn(hObject, eventdata, handles)
% hObject    handle to entrada_lista (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in play_entrada.
function play_entrada_Callback(hObject, eventdata, handles)
% hObject    handle to play_entrada (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
resume(handles.x_audio)


%% Controles de reproducción
% --- Executes on button press in stop_entrada.
function stop_entrada_Callback(hObject, eventdata, handles)
% hObject    handle to stop_entrada (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stop(handles.x_audio)


% --- Executes on button press in pause_entrada.
function pause_entrada_Callback(hObject, eventdata, handles)
% hObject    handle to pause_entrada (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pause(handles.x_audio)


% --- Executes on button press in play_salida.
function play_salida_Callback(hObject, eventdata, handles)
% hObject    handle to play_salida (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
resume(handles.y_audio)


% --- Executes on button press in stop_salida.
function stop_salida_Callback(hObject, eventdata, handles)
% hObject    handle to stop_salida (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stop(handles.y_audio)


% --- Executes on button press in pause_salida.
function pause_salida_Callback(hObject, eventdata, handles)
% hObject    handle to pause_salida (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pause(handles.y_audio)


%% Ampliar gráficas
% --- Executes on button press in entrada_L_open.
function entrada_L_open_Callback(hObject, eventdata, handles)
% hObject    handle to entrada_L_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
z_entrada_L_open


% --- Executes on button press in entrada_R_open.
function entrada_R_open_Callback(hObject, eventdata, handles)
% hObject    handle to entrada_R_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
z_entrada_R_open


% --- Executes on button press in entrada_espectro_open.
function entrada_espectro_open_Callback(hObject, eventdata, handles)
% hObject    handle to entrada_espectro_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
z_entrada_espectro_open


% --- Executes on button press in salida_L_open.
function salida_L_open_Callback(hObject, eventdata, handles)
% hObject    handle to salida_L_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
z_salida_L_open


% --- Executes on button press in salida_R_open.
function salida_R_open_Callback(hObject, eventdata, handles)
% hObject    handle to salida_R_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
z_salida_R_open


% --- Executes on button press in salida_espectro_open.
function salida_espectro_open_Callback(hObject, eventdata, handles)
% hObject    handle to salida_espectro_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
z_salida_espectro_open


% --- Executes on button press in comparar.
function comparar_Callback(hObject, eventdata, handles)
% hObject    handle to salida_espectro_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
z_comparar


%% Controles de parámetros
% --- Executes during object creation, after setting all properties.
function par_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to par_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function par_1_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to par_1_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in par_1_LFO.
function par_1_LFO_Callback(hObject, eventdata, handles)
% hObject    handle to par_1_LFO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = z_LFO(handles,1);
% Update handles structure
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of par_1_LFO


% --- Executes during object creation, after setting all properties.
function par_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to par_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function par_2_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to par_2_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in par_2_LFO.
function par_2_LFO_Callback(hObject, eventdata, handles)
% hObject    handle to par_2_LFO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = z_LFO(handles,2);
% Update handles structure
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of par_2_LFO


% --- Executes during object creation, after setting all properties.
function par_3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to par_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function par_3_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to par_3_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in par_3_LFO.
function par_3_LFO_Callback(hObject, eventdata, handles)
% hObject    handle to par_3_LFO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = z_LFO(handles,3);
% Update handles structure
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of par_3_LFO


% --- Executes during object creation, after setting all properties.
function par_4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to par_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function par_4_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to par_4_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in par_4_LFO.
function par_4_LFO_Callback(hObject, eventdata, handles)
% hObject    handle to par_4_LFO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = z_LFO(handles,4);
% Update handles structure
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of par_4_LFO


% --- Executes during object creation, after setting all properties.
function par_5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to par_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function par_5_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to par_5_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in par_5_LFO.
function par_5_LFO_Callback(hObject, eventdata, handles)
% hObject    handle to par_5_LFO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = z_LFO(handles,5);
% Update handles structure
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of par_5_LFO


% --- Executes during object creation, after setting all properties.
function par_6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to par_6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function par_6_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to par_6_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in par_6_LFO.
function par_6_LFO_Callback(hObject, eventdata, handles)
% hObject    handle to par_6_LFO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = z_LFO(handles,6);
% Update handles structure
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of par_6_LFO