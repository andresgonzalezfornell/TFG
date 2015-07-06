%% Ampliacion del grafico de la salida

if isfield(handles,'y')
    figure('name','Salida canal L')
    n = [1:length(handles.y(:,1))];
    t = n/44100;
    plot(t,handles.y(:,1),'green')
    xlabel('Tiempo [s] (canal L)')
end