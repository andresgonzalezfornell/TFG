%% Comparación entre espectros de entrada y salida

if isfield(handles,'Y_L') && isfield(handles,'Y_R') && isfield(handles,'X_L') && isfield(handles,'X_R')
    figure('name','Espectros de entrada y salida')
    if length(handles.x(:,1)) < length(handles.y(:,1))
        n = [1:length(handles.x(:,1))];
    else
        n = [1:length(handles.y(:,1))];
    end
    f = 0+handles.fs/length(n):handles.fs/length(n):handles.fs/2;
    hold on
    subplot(2,1,1)
	stairs(f,abs(handles.X_R),'red')
	stairs(f,abs(handles.X_L),'green')
	xlabel('Frecuencia [Hz] (entrada)')
    subplot(2,1,2)
	stairs(f,abs(handles.Y_R),'red')
	stairs(f,abs(handles.Y_L),'green')   
	xlabel('Frecuencia [Hz] (salida)')
    hold off
end