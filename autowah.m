function varargout = autowah(varargin)
% Efecto de AUTOWAH
% 
%      Si desea pasar la salida del efecto a su workspace escriba:
%
%                   y = autowah;
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
%   Copiar template.m y template.fig modificando template por el nombre del efecto (autowah) y editar el autowah.m
%   Buscar y reemplazar:
%       autowah        por nombre del efecto siguiendo el formato (ej.: overdrive)
%       Autowah        por nombre del efecto siguiendo el formato (ej.: Overdrive)
%       AUTOWAH        por nombre del efecto siguiendo el formato (ej.: OVERDRIVE)
%       <Descripción>   por la descripci�n del efecto
%   Implementar el efecto en la funci�n aplicar_callback.
%   Inicializar los parámetros siguiendo el formato de ejemplo en la función autowah_OpeningFcn
%   Implementar los parámetros en las funciones par_<#>_Callback
%   Modificar en el archivo autowah.fig los callbacks de los botones

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @autowah_OpeningFcn, ...
                   'gui_OutputFcn',  @autowah_OutputFcn, ...
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

% Autowah
resolucion = 2000;                    % Muestras por cada actualización de filtrado
f_0 = handles.f_inicial;
BW = handles.BW;
f_1 = f_0-BW/2;
f_2 = f_0+BW/2;
T_LFO = 1/handles.f_LFO;                        % Periodo del LFO
N_LFO = round(T_LFO*handles.fs/2/resolucion);   % Número de actualizaciones en un ciclo del LFO
incremento = handles.rango/N_LFO/2;             % Paso de frecuencias que dará el filtro
% Se cambiará el filtro cada 20 muestras
fin = floor(length(handles.x(:,1))/resolucion);
for n = 1:fin
    % Si llega a los límites
    if (f_0 >= handles.f_inicial+handles.rango/2) || (f_0 <= handles.f_inicial-handles.rango/2)
        incremento = -incremento;
        info = strcat(num2str(n/fin*100,'%.2f'),'% de señal procesada')
    end
    % Filtro
    filtro = designfilt('bandpassfir','FilterOrder',10,'CutoffFrequency1',f_1,'CutoffFrequency2',f_2,'SampleRate',handles.fs);
    handles.y((n-1)*resolucion+1:n*resolucion,:) = filter(filtro,handles.x((n-1)*resolucion+1:n*resolucion,:));
    % Incremento de frecuencia
    f_0 = f_0 + incremento;
    f_1 = f_0-BW/2;
    f_2 = f_0+BW/2;
end
% Filtrado restante
%filtro = designfilt('bandpassfir','FilterOrder',2,'CutoffFrequency1',f_1,'CutoffFrequency2',f_2,'SampleRate',handles.fs);
%handles.y(fin*resolucion+1:end,:) = filter(filtro,handles.x(fin*resolucion+1:end,:));

z_interfaz_salida


%% Parámetros
% --- Executes on slider movement.
function par_1_Callback(hObject, eventdata, handles)
% hObject    handle to par_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.mix = get(hObject,'Value');
set(handles.par_1_value,'String',handles.mix)
% Update handles structure
guidata(hObject, handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


function par_1_value_Callback(hObject, eventdata, handles)
% hObject    handle to par_1_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if str2double(get(hObject,'String'))>=0 && str2double(get(hObject,'String'))<=1
    handles.mix = str2double(get(hObject,'String'));
    set(handles.par_1,'Value',handles.mix)
else
    set(handles.par_1_value,'String',handles.mix)
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
handles.f_LFO = get(hObject,'Value');
set(handles.par_2_value,'String',handles.f_LFO)
% Update handles structure
guidata(hObject, handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

function par_2_value_Callback(hObject, eventdata, handles)
% hObject    handle to par_2_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if str2double(get(hObject,'String'))>=0.1 && str2double(get(hObject,'String'))<=10
    handles.f_LFO = str2double(get(hObject,'String'));
    set(handles.par_2,'Value',handles.f_LFO)
else
    set(handles.par_2_value,'String',handles.f_LFO)
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
handles.f_inicial = get(hObject,'Value');
set(handles.par_3_value,'String',handles.f_inicial)
if handles.f_inicial-handles.rango/2 <= handles.BW      % El rango sobrepasa por los negativos
    handles.rango = 2*handles.f_inicial-handles.BW;
    set(handles.par_4,'Value',handles.rango,'Max',handles.rango)
    set(handles.par_4_value,'String',handles.rango)
elseif handles.f_inicial+handles.rango/2 >= 20000       % El rango sobrepasa por los positivos
    handles.rango = 2*(20000-handles.f_inicial);
    set(handles.par_4,'Value',handles.rango,'Max',handles.rango)
    set(handles.par_4_value,'String',handles.rango)
end
% Update handles structure
guidata(hObject, handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


function par_3_value_Callback(hObject, eventdata, handles)
% hObject    handle to par_3_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if str2double(get(hObject,'String'))>=1000 && str2double(get(hObject,'String'))<=19000
    handles.f_inicial = str2double(get(hObject,'String'));
    set(handles.par_3,'Value',handles.f_inicial)
    if handles.f_inicial-handles.rango/2 <= handles.BW      % El rango sobrepasa por los negativos
        handles.rango = 2*handles.f_inicial-handles.BW;
        set(handles.par_4,'Value',handles.rango,'Max',handles.rango)
        set(handles.par_4_value,'String',handles.rango)
    elseif handles.f_inicial+handles.rango/2 >= 20000       % El rango sobrepasa por los positivos
        handles.rango = 2*(20000-handles.f_inicial);
        set(handles.par_4,'Value',handles.rango,'Max',handles.rango)
        set(handles.par_4_value,'String',handles.rango)
    end
else
    set(handles.par_3_value,'String',handles.f_inicial)
end
% Update handles structure
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of par_3_value as text
%        str2double(get(hObject,'String')) returns contents of par_3_value as a double


% --- Executes on slider movement.
function par_4_Callback(hObject, eventdata, handles)
% hObject    handle to par_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.rango = get(hObject,'Value');
set(handles.par_4_value,'String',handles.rango)
% Update handles structure
guidata(hObject, handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


function par_4_value_Callback(hObject, eventdata, handles)
% hObject    handle to par_4_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (handles.f_inicial-str2double(get(hObject,'String'))/2) > 0                  % El rango no sobrepasa por los negativos
    if (handles.f_inicial-str2double(get(hObject,'String'))/2) < handles.BW     % El rango no sobrepasa por los positivos
        handles.rango = str2double(get(hObject,'String'));
        set(handles.par_4,'Value',handles.rango)
    else
        handles.rango = 2*(20000-handles.f_inicial);
        set(handles.par_4,'Value',handles.rango)
        set(handles.par_4_value,'String',handles.rango)
    end
else
    handles.rango = 2*handles.f_inicial;
    set(handles.par_4,'Value',handles.rango)
    set(handles.par_4_value,'String',handles.rango)
end
% Update handles structure
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of par_4_value as text
%        str2double(get(hObject,'String')) returns contents of par_4_value as a double


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
else
end
% Update handles structure
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of par_6_value as text
%        str2double(get(hObject,'String')) returns contents of par_6_value as a double


%% Gr�fica del efecto
% --- Executes on button press in graf_open.
function graf_open_Callback(hObject, eventdata, handles)
% hObject    handle to graf_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Controles de interfaz
% --- Executes just before autowah is made visible.
function autowah_OpeningFcn(hObject, eventdata, handles, varargin)
% Descripción del efecto
set(handles.titulo,'String','Autowah')
set(handles.des,'String',{'Filtro paso banda estrecho con una frecuencia central variable.','','Puesto que es autom�tico, la señal que controla la frecuencia central (LFO) es una señal triangular. La frecuencia media (inicial) se ha establecido en 8000Hz'})
% Inicialización de parámetros
handles.BW = 200;
handles.mix = 0.7;
set(handles.par_1,'Visible','on','Value',handles.mix)
set(handles.par_1_value,'Visible','on','String',0.7)
set(handles.par_1_title,'Visible','on','String','Nivel de autowah')
handles.f_LFO = 1;
set(handles.par_2,'Visible','on','Value',handles.f_LFO,'Min',0.1,'Max',10)
set(handles.par_2_value,'Visible','on','String',1)
set(handles.par_2_title,'Visible','on','String','Frecuencia de LFO [Hz]')
handles.f_inicial = 10000;
set(handles.par_3,'Visible','on','Value',handles.f_inicial,'Min',5000+handles.BW,'Max',15000)
set(handles.par_3_value,'Visible','on','String',10000)
set(handles.par_3_title,'Visible','on','String','Frecuencia central de LFO [Hz]')
handles.rango = 10000;
set(handles.par_4,'Visible','on','Value',handles.rango,'Min',5*handles.BW,'Max',20000-handles.BW/2)
set(handles.par_4_value,'Visible','on','String',10000)
set(handles.par_4_title,'Visible','on','String','Frecuencia central de LFO [Hz]')
% Representación del LFO
lfo = zeros(40);
for n = 1:40
    if n <= 10
        lfo = n*handles.BW*handles.f_LFO/2;
    elseif (n > 10) && (n <= 30)
        lfo = -n*handles.BW*handles.f_LFO/2+handles.BW;
    else
        lfo = n*handles.BW*handles.f_LFO/2+2*handles.BW;
    end
end
n = 1:1/handles.f_LFO/40:1/handles.f_LFO;
plot(handles.graf,n,lfo)
% Interfaz
z_interfaz_OpeningFcn
% UIWAIT makes autowah wait for user response (see UIRESUME)


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
function varargout = autowah_OutputFcn(hObject, eventdata, handles) 
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
