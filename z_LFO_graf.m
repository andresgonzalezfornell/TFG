tipo = get(handles.tipo,'SelectedObject');
res = 0.01;
handles.LFO.n = 0:res:5;
switch tipo.String
    case 'Sinusoidal'
        handles.LFO.x = handles.LFO.amplitud*sin(2*pi*handles.LFO.frecuencia*handles.LFO.n)+handles.LFO.offset;
end
plot(handles.graf,handles.LFO.n,handles.LFO.x)
set(handles.graf,'YLim',[handles.limites.Min handles.limites.Max])
xlabel(handles.graf,'Tiempo [s]')