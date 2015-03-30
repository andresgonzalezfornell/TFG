%% Ampliación del gráfico del espectro de salida

if isfield(handles,'Y_L') && isfield(handles,'Y_R')
    figure('name','Salida espectro')
    n = [1:length(handles.y(:,1))];
    f = 0+handles.fs/length(n):handles.fs/length(n):handles.fs/2;
    hold on
    stairs(f,abs(handles.Y_R),'red')
	stairs(f,abs(handles.Y_L),'green')
	xlabel('Frecuencia [Hz]')
    hold off
end