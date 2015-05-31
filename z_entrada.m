%% Fichero de entrada

handles.x_audio = audioplayer(handles.x,handles.fs);
n = 1:length(handles.x(:,1));
t = n/handles.fs;
f = 0+handles.fs/length(n):handles.fs/length(n):handles.fs/2;
% Mono
if length(handles.x(1,:)) == 1
    x(:,2) = handles(1,:);
end
X_L = fft(handles.x(:,1))/length(n);
X_R = fft(handles.x(:,2))/length(n);
handles.X_L = X_L(1:floor(length(n)/2));
handles.X_R = X_R(1:floor(length(n)/2));
%handles.X = (handles.X_L+handles.X_R)/2;
cla(handles.entrada_espectro)
hold(handles.entrada_espectro,'on')
loglog(handles.entrada_espectro,f,abs(handles.X_R),'red')
loglog(handles.entrada_espectro,f,abs(handles.X_L),'green')
set(handles.entrada_espectro,'XLim',[20 20000],'XGrid','on')
hold(handles.entrada_espectro,'off')
xlabel(handles.entrada_espectro,'Frecuencia [Hz]')
for i = 1:6
    handles.limites(i).longitud = length(handles.x(:,1))/handles.fs;
end