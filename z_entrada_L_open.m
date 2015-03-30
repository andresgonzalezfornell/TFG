%% Ampliación del gráfico de la entrada

if isfield(handles,'x')
    figure('name','Entrada canal L')
    n = [1:length(handles.x(:,1))];
    t = n/44100;
    plot(t,handles.x(:,1),'green')
    xlabel('Tiempo [s] (canal L)')
end