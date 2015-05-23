function varargout = phaser(varargin)
% Efecto de PHASER
% 
%      Si desea pasar la salida del efecto a su workspace escriba:
%
%                   y = phaser;
%
%      La variable devuelta "y" se corresponde con un array
%      multidimensional formado por las siguientes senales
%       y(:,1) senal canal L
%       y(:,2) senal canal R
%       y(:,3) espectro de senal canal L
%       y(:,4) espectro de senal canal R
%       y(:,5) espectro de senal media entre ambos canales
%      Nota: puede cambiar el nombre de la variable "y" por la que desee.

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @phaser_OpeningFcn, ...
                   'gui_OutputFcn',  @phaser_OutputFcn, ...
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

% Phaser
x = handles.x;
BW_1 = handles.BW_1;
BW_2 = handles.BW_2;
BW_3 = handles.BW_3;
f_1_min = handles.f_1 - BW_1/2;
f_2_min = handles.f_2 - BW_2/2;
f_3_min = handles.f_3 - BW_3/2;
f_1_max = handles.f_1 + BW_1/2;
f_2_max = handles.f_2 + BW_2/2;
f_3_max = handles.f_3 + BW_3/2;
mix = handles.mix;
filtro_1 = designfilt('bandstopfir','FilterOrder',10,'CutoffFrequency1',f_1_min,'CutoffFrequency2',f_1_max,'SampleRate',handles.fs);
filtro_2 = designfilt('bandstopfir','FilterOrder',10,'CutoffFrequency1',f_2_min,'CutoffFrequency2',f_2_max,'SampleRate',handles.fs);
filtro_3 = designfilt('bandstopfir','FilterOrder',10,'CutoffFrequency1',f_3_min,'CutoffFrequency2',f_3_max,'SampleRate',handles.fs);
phaser = filter(filtro_1,x);
phaser = filter(filtro_2,phaser);
phaser = filter(filtro_3,phaser);
if handles.LFO_1.checkbox || handles.LFO_2.checkbox                             % Con LFO
    res.LFO = 200;
    res.y = floor(length(handles.x(:,1))/handles.LFO_N);
    wb = waitbar(0,'Processing...');                                % Dialogo de espera
    for n = 1:res.LFO:handles.LFO_N
        if handles.LFO_1.checkbox                                               % LFO 1
            f_0 = handles.LFO_1.x(n);
            f_1_min = f_0*handles.f_1_ref - BW_1/2;
            f_2_min = f_0*handles.f_2_ref - BW_2/2;
            f_3_min = f_0*handles.f_3_ref - BW_3/2;
            f_1_max = f_0*handles.f_1_ref + BW_1/2;
            f_2_max = f_0*handles.f_2_ref + BW_2/2;
            f_3_max = f_0*handles.f_3_ref + BW_3/2;
            filtro_1 = designfilt('bandstopfir','FilterOrder',10,'CutoffFrequency1',f_1_min,'CutoffFrequency2',f_1_max,'SampleRate',handles.fs);
            filtro_2 = designfilt('bandstopfir','FilterOrder',10,'CutoffFrequency1',f_2_min,'CutoffFrequency2',f_2_max,'SampleRate',handles.fs);
            filtro_3 = designfilt('bandstopfir','FilterOrder',10,'CutoffFrequency1',f_3_min,'CutoffFrequency2',f_3_max,'SampleRate',handles.fs);
            phaser((n-1)*res.y+1:n*res.y,:) = filter(filtro_1,x((n-1)*res.y+1:n*res.y,:));
            phaser((n-1)*res.y+1:n*res.y,:) = filter(filtro_2,phaser((n-1)*res.y+1:n*res.y,:));
            phaser((n-1)*res.y+1:n*res.y,:) = filter(filtro_3,phaser((n-1)*res.y+1:n*res.y,:));
        end
        if handles.LFO_2.checkbox                                               % LFO 2
            mix((n-1)*res.y+1:n*res.y) = handles.LFO_2.x(n);
        end
        waitbar(n/handles.LFO_N,wb,'Processing...');       % Dialogo de espera
    end
end
handles.y = (1-mix).*x + mix.*phaser;

z_interfaz_salida


%% Parametros
% --- Executes on slider movement.
function par_1_Callback(hObject, eventdata, handles)
% hObject    handle to par_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.f_0 = get(hObject,'Value');
handles.f_1 = handles.f_0*handles.f_1_ref;
handles.f_2 = handles.f_0*handles.f_2_ref;
handles.f_3 = handles.f_0*handles.f_3_ref;
set(handles.par_1_value,'String',handles.f_0)
handles = LFO_plot(handles);
% Update handles structure
guidata(hObject, handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


function par_1_value_Callback(hObject, eventdata, handles)
% hObject    handle to par_1_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if str2double(get(hObject,'String'))>=handles.limites(2).Min && str2double(get(hObject,'String'))<=handles.limites(2).Max
    handles.f_0 = str2double(get(hObject,'String'));
    handles.f_1 = handles.f_0*handles.f_1_ref;
    handles.f_2 = handles.f_0*handles.f_2_ref;
    handles.f_3 = handles.f_0*handles.f_3_ref;
    set(handles.par_1,'Value',handles.f_0)
else
    set(handles.par_1_value,'String',handles.f_0)
end
handles = LFO_plot(handles);
% Update handles structure
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of par_1_value as text
%        str2double(get(hObject,'String')) returns contents of par_1_value as a double


% --- Executes on button press in par_1_LFO.
function par_1_LFO_Callback(hObject, eventdata, handles)
% hObject    handle to par_1_LFO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = z_LFO(handles,1);
handles = LFO_plot(handles);
% Update handles structure
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of par_1_LFO


% --- Executes on slider movement.
function par_2_Callback(hObject, eventdata, handles)
% hObject    handle to par_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.mix = get(hObject,'Value');
set(handles.par_2_value,'String',get(hObject,'Value'))
handles = LFO_plot(handles);
% Update handles structure
guidata(hObject, handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

function par_2_value_Callback(hObject, eventdata, handles)
% hObject    handle to par_2_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if str2double(get(hObject,'String'))>=handles.limites(2).Min & str2double(get(hObject,'String'))<=handles.limites(2).Max
    handles.mix = str2double(get(hObject,'String'));
    set(handles.par_2,'Value',str2double(get(hObject,'String')))
else
    set(handles.par_2_value,'String',handles.mix)
end
handles = LFO_plot(handles);
% Update handles structure
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of par_2_value as text
%        str2double(get(hObject,'String')) returns contents of par_2_value as a double


% --- Executes on button press in par_2_LFO.
function par_2_LFO_Callback(hObject, eventdata, handles)
% hObject    handle to par_2_LFO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = z_LFO(handles,2);
handles = LFO_plot(handles);
% Update handles structure
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of par_2_LFO


% --- Executes on slider movement.
function par_3_Callback(hObject, eventdata, handles)
% hObject    handle to par_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Update handles structure
guidata(hObject, handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

function par_3_value_Callback(hObject, eventdata, handles)
% hObject    handle to par_3_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Update handles structure
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of par_3_value as text
%        str2double(get(hObject,'String')) returns contents of par_3_value as a double


% --- Executes on button press in par_3_LFO.
function par_3_LFO_Callback(hObject, eventdata, handles)
% hObject    handle to par_3_LFO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = z_LFO(handles,3);
% Update handles structure
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of par_3_LFO


% --- Executes on slider movement.
function par_4_Callback(hObject, eventdata, handles)
% hObject    handle to par_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Update handles structure
guidata(hObject, handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


function par_4_value_Callback(hObject, eventdata, handles)
% hObject    handle to par_4_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Update handles structure
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of par_4_value as text
%        str2double(get(hObject,'String')) returns contents of par_4_value as a double


% --- Executes on button press in par_4_LFO.
function par_4_LFO_Callback(hObject, eventdata, handles)
% hObject    handle to par_4_LFO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = z_LFO(handles,4);
% Update handles structure
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of par_4_LFO


% --- Executes on slider movement.
function par_5_Callback(hObject, eventdata, handles)
% hObject    handle to par_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Update handles structure
guidata(hObject, handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


function par_5_value_Callback(hObject, eventdata, handles)
% hObject    handle to par_5_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Update handles structure
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of par_5_value as text
%        str2double(get(hObject,'String')) returns contents of par_5_value as a double


% --- Executes on button press in par_5_LFO.
function par_5_LFO_Callback(hObject, eventdata, handles)
% hObject    handle to par_5_LFO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = z_LFO(handles,5);
% Update handles structure
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of par_5_LFO


% --- Executes on slider movement.
function par_6_Callback(hObject, eventdata, handles)
% hObject    handle to par_6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Update handles structure
guidata(hObject, handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


function par_6_value_Callback(hObject, eventdata, handles)
% hObject    handle to par_6_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Update handles structure
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of par_6_value as text
%        str2double(get(hObject,'String')) returns contents of par_6_value as a double


% --- Executes on button press in par_6_LFO.
function par_6_LFO_Callback(hObject, eventdata, handles)
% hObject    handle to par_6_LFO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = z_LFO(handles,6);
% Update handles structure
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of par_6_LFO


%% Controles de interfaz
% --- Executes just before phaser is made visible.
function phaser_OpeningFcn(hObject, eventdata, handles, varargin)
% Descripci�n del efecto
set(handles.titulo,'String','Phaser')
set(handles.des,'String','Conjunto de filtros de banda eliminada estrecha (notch filter) con frecuencia central variable controlado por un oscilador de baja frecuencia. El fuerte cambio de fase existente alrededor de la banda eliminada se combina con las fases de la se�al directa y causa cancelaciones o refuerzos de fase.')
% Inicializacion de parametros
handles.BW_1 = 10;
handles.BW_2 = 100;
handles.BW_3 = 1000;
handles.f_0 = 0.5;
handles.f_1_ref = 200;
handles.f_2_ref = 2000;
handles.f_3_ref = 20000;
handles.f_1 = handles.f_0*handles.f_1_ref;
handles.f_2 = handles.f_0*handles.f_2_ref;
handles.f_3 = handles.f_0*handles.f_3_ref;
handles.limites(1).Min = 0.25;
handles.limites(1).Max = 1;
set(handles.par_1,'Visible','on','Value',handles.f_0)
set(handles.par_1_value,'Visible','on','String',handles.f_0)
set(handles.par_1_title,'Visible','on','String','Frecuencia central relativa de filtros')
set(handles.par_1_LFO,'Visible','on')
set(handles.graf,'Visible','on')
set(handles.graf_open,'Visible','on')
handles.mix = 0.7;
handles.limites(2).Min = 0;
handles.limites(2).Max = 1;
set(handles.par_2,'Visible','on','Value',handles.mix)
set(handles.par_2_value,'Visible','on','String',handles.mix)
set(handles.par_2_title,'Visible','on','String','Nivel de phaser')
set(handles.par_2_LFO,'Visible','on')
% LFO (necesario para el grafico del efecto)
handles.LFO_1.checkbox = 0;
handles.LFO_2.checkbox = 0;
handles.LFO_3.checkbox = 0;
handles.LFO_4.checkbox = 0;
handles.LFO_5.checkbox = 0;
handles.LFO_6.checkbox = 0;
% Grafico del efecto
handles = LFO_plot(handles);
% Interfaz
z_interfaz_OpeningFcn
% UIWAIT makes phaser wait for user response (see UIRESUME)


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
function varargout = phaser_OutputFcn(hObject, eventdata, handles) 
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


%% Ampliar graficas
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


% --- Executes on button press in graf_open.
function graf_open_Callback(hObject, eventdata, handles)
% hObject    handle to graf_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
z_graf_open


% --- Executes on button press in comparar.
function comparar_Callback(hObject, eventdata, handles)
% hObject    handle to salida_espectro_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
z_comparar


%% Controles de par�metros
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


function [handles] = LFO_plot(handles)
% Representacion del LFO
handles.grafico.title = 'Filtros phaser';
cla(handles.graf)
n = 0:20500;
if handles.LFO_1.checkbox                               % LFO 1
    f_0 = handles.LFO_1.offset;
else
    f_0 = handles.f_0;
end
if handles.LFO_2.checkbox                               % LFO 2
    mix = handles.LFO_2.offset;
else
    mix = handles.mix;
end
f_1_min = round(f_0*handles.f_1_ref - handles.BW_1/2);
f_2_min = round(f_0*handles.f_2_ref - handles.BW_2/2);
f_3_min = round(f_0*handles.f_3_ref - handles.BW_3/2);
f_1_max = round(f_0*handles.f_1_ref + handles.BW_1/2);
f_2_max = round(f_0*handles.f_2_ref + handles.BW_2/2);
f_3_max = round(f_0*handles.f_3_ref + handles.BW_3/2);
hold(handles.graf,'on')
set(rectangle('Position',[0 1 20000 0.25],'FaceColor',[1 1 1]),'EdgeColor','none','parent',handles.graf)
set(line([0 20000],[1 1]),'Color','black','parent',handles.graf)
% Nivel de señal sin efecto
x(n+1) = 1-mix;
set(area(n,x,'FaceColor',[0.667 0.875 0.71]),'EdgeColor','none','parent',handles.graf)
% Filtro 1
lfo_1(1:f_1_min) = mix;
lfo_1(f_1_min+1:f_1_max+1) = 0;
lfo_1(f_1_max+2:round(sqrt(f_1_max*f_2_min)+1)) = mix;
set(area(n(1:length(lfo_1)),lfo_1),'FaceColor',[0.698 0.765 1],'parent',handles.graf)
% Filtro 2
lfo_2(round(sqrt(f_1_max*f_2_min)+1):f_2_min) = mix;
lfo_2(f_2_min+1:f_2_max+1) = 0;
lfo_2(f_2_max+2:round(sqrt(f_2_max*f_3_min)+1)) = mix;
set(area(n(length(lfo_1)+1:length(lfo_2)),lfo_2(length(lfo_1)+1:length(lfo_2))),'FaceColor',[1 0.792 0.416],'parent',handles.graf)
% Filtro 3
lfo_3(round(sqrt(f_2_max*f_3_min)+1):f_3_min) = mix;
lfo_3(f_3_min+1:f_3_max+1) = 0;
lfo_3(f_3_max+2:20501) = mix;
set(area(n(length(lfo_2)+1:length(lfo_3)),lfo_3(length(lfo_2)+1:length(lfo_3))),'FaceColor',[1 0.486 0.412],'parent',handles.graf)
if handles.LFO_1.checkbox                               % LFO 1
    % f_1
    f_1_min = round(handles.f_1_ref*handles.LFO_1.offset-handles.BW_1/2);
    f_1_max = round(handles.f_1_ref*handles.LFO_1.offset+handles.BW_1/2);
    set(line([(f_1_min-handles.f_1_ref*handles.LFO_1.amplitud) (f_1_min-handles.f_1_ref*handles.LFO_1.amplitud)],[0 2],'LineStyle','--','Color',[0.306 0.337 0.439]),'parent',handles.graf)
    set(line([(f_1_max+handles.f_1_ref*handles.LFO_1.amplitud) (f_1_max+handles.f_1_ref*handles.LFO_1.amplitud)],[0 2],'LineStyle','--','Color',[0.306 0.337 0.439]),'parent',handles.graf)
    % f_2
    f_2_min = round(handles.f_2_ref*handles.LFO_1.offset-handles.BW_2/2);
    f_2_max = round(handles.f_2_ref*handles.LFO_1.offset+handles.BW_2/2);
    set(line([(f_2_min-handles.f_2_ref*handles.LFO_1.amplitud) (f_2_min-handles.f_2_ref*handles.LFO_1.amplitud)],[0 2],'LineStyle','--','Color',[0.612 0.482 0.255]),'parent',handles.graf)
    set(line([(f_2_max+handles.f_2_ref*handles.LFO_1.amplitud) (f_2_max+handles.f_2_ref*handles.LFO_1.amplitud)],[0 2],'LineStyle','--','Color',[0.612 0.482 0.255]),'parent',handles.graf)
    % f_3
    f_3_min = round(handles.f_3_ref*handles.LFO_1.offset-handles.BW_3/2);
    f_3_max = round(handles.f_3_ref*handles.LFO_1.offset+handles.BW_3/2);
    set(line([(f_3_min-handles.f_3_ref*handles.LFO_1.amplitud) (f_3_min-handles.f_3_ref*handles.LFO_1.amplitud)],[0 2],'LineStyle','--','Color',[0.698 0.341 0.286]),'parent',handles.graf)
    set(line([(f_3_max+handles.f_3_ref*handles.LFO_1.amplitud) (f_3_max+handles.f_3_ref*handles.LFO_1.amplitud)],[0 2],'LineStyle','--','Color',[0.698 0.341 0.286]),'parent',handles.graf)
end
if handles.LFO_2.checkbox                               % LFO 2
    mix_Max = mix + handles.LFO_2.amplitud;
    mix_Min = mix - handles.LFO_2.amplitud;
    if f_0 >= 0.9           % Representacion en la izquierda
        set(line([500 500],[mix_Min mix_Max]),'parent',handles.graf,'Color','black')
        set(line([500 1000],[mix_Min mix_Min]),'parent',handles.graf,'Color','black')
        set(line([500 1000],[mix_Max mix_Max]),'parent',handles.graf,'Color','black')
    else                    % Representacion en la derecha
        set(line([19500 19500],[mix_Min mix_Max]),'parent',handles.graf,'Color','black')
        set(line([19000 19500],[mix_Min mix_Min]),'parent',handles.graf,'Color','black')
        set(line([19000 19500],[mix_Max mix_Max]),'parent',handles.graf,'Color','black')
    end
end
set(handles.graf,'XLim',[20 20000],'YLim',[0 1.25],'YTick',[],'XGrid','on')
handles.graf.XLabel.String = 'Frecuencia [Hz]';
handles.graf.Title.String = 'Filtros de phaser';
hold(handles.graf,'off')