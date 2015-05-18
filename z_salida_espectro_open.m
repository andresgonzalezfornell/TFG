%% Ampliación del gráfico del espectro de salida

if isfield(handles,'Y_L') && isfield(handles,'Y_R')
    figure('name','Salida espectro')
    n = [1:length(handles.y(:,1))];
    f = 0+handles.fs/length(n):handles.fs/length(n):handles.fs/2;
    hold on
    loglog(f,abs(handles.Y_R),'red')
	loglog(f,abs(handles.Y_L),'green')
	xlabel('Frecuencia [Hz]')
    hold off
end