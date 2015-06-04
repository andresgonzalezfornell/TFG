% Limpieza de salida

set(handles.play_salida,'Enable','Off')
set(handles.stop_salida,'Enable','Off')
set(handles.pause_salida,'Enable','Off')
clear handles.y
cla(handles.salida_L)
cla(handles.salida_R)
cla(handles.salida_espectro)