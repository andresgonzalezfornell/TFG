% Limpieza de salida

if isfield(handles,'x_audio')
    stop(handles.x_audio)
end
if isfield(handles,'y_audio')
    stop(handles.y_audio)
end
set(handles.play_salida,'Enable','Off')
set(handles.stop_salida,'Enable','Off')
set(handles.pause_salida,'Enable','Off')
clear handles.y
cla(handles.salida_L)
cla(handles.salida_R)
cla(handles.salida_espectro)