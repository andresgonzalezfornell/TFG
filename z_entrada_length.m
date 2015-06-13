%% Cambio de longitud del generador de audio

if ~(str2double(get(handles.entrada_length,'String')) > 0 && str2double(get(handles.entrada_length,'String')) <= 300)
    set(handles.entrada_length,'String',2)
end
if handles.LFO_0.checkbox
    set(handles.entrada_oscilador,'Value',0)
    handles = z_LFO(handles,0);
end