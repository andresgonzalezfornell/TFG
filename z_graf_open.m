%% Ampliación del gráfico del efecto

f = figure('name','Gráfico del efecto');
copyobj(handles.graf,f)
graf = get(f,'Children');
set(graf,'Units','normalized','Position',[0.1300 0.1100 0.7750 0.8150])

% Update handles structure
guidata(hObject, handles);