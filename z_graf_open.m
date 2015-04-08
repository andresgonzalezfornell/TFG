%% Ampliación del gráfico del efecto
f = figure('name','Gráfico del efecto');
position = get(f,'Position');
copyobj(handles.graf,f)
graf = get(f,'Children');
set(graf,'Units','normalized','Position',[0.1300 0.1100 0.7750 0.8150])
graf.XLabel.String = handles.graf.XLabel.String

% Paso de parámetros adicionales
if isfield(handles.grafico,'title')
    graf.Title.String = handles.grafico.title;
    graf.Title
end
if isfield(handles.grafico,'legend')
    
    legend(graf,handles.grafico.title)
end

% Update handles structure
guidata(hObject, handles);