%% Ampliacion del grafico de la entrada

if isfield(handles,'x')
    figure('name','Entrada canal R')
    n = [1:length(handles.x(:,2))];
    t = n/44100;
    plot(t,handles.x(:,2),'red')
    xlabel('Tiempo [s] (canal R)')
end