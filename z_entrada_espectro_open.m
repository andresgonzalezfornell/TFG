%% Ampliación del gráfico del espectro de entrada

if isfield(handles,'X_L') && isfield(handles,'X_R')
    figure('name','Entrada espectro')
    n = [1:length(handles.x(:,1))];
    f = 0+handles.fs/length(n):handles.fs/length(n):handles.fs/2;
    hold on
	stairs(f,abs(handles.X_R),'red')
	stairs(f,abs(handles.X_L),'green')
	xlabel('Frecuencia [Hz]')
    hold off
end