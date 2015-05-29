%% Ampliación del gráfico de la salida

if isfield(handles,'y')
    figure('name','Salida canal R')
    n = [1:length(handles.y(:,2))];
    t = n/44100;
    plot(t,handles.y(:,2),'red')
    xlabel('Tiempo [s] (canal R)')
end