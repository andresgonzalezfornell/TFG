%% Ampliación del gráfico del espectro de entrada

if isfield(handles,'X_L') && isfield(handles,'X_R')
    figure('name','Entrada espectro')
    n = [1:length(handles.x(:,1))];
    f = 0+handles.fs/length(n):handles.fs/length(n):handles.fs/2;
    hold on
	loglog(f,abs(handles.X_R),'red')
	loglog(f,abs(handles.X_L),'green')
    grid on
	xlabel('Frecuencia [Hz]')
    hold off
end