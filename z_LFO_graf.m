% Limpieza de variables
if isfield(handles.LFO,'n')
    handles.LFO = rmfield(handles.LFO,'n');
end
if isfield(handles.LFO,'x')
    handles.LFO = rmfield(handles.LFO,'x');
end
tipo = get(handles.tipo_panel,'SelectedObject');
handles.LFO.tipo = tipo.String;
Ts = 0.001;                     % Periodo de muestreo
T = 1/handles.LFO.frecuencia;   % Periodo de señal
L = floor(T/Ts);                % Número de muestras de un periodo de señal
handles.LFO.n = Ts:Ts:handles.limites.longitud;
switch tipo.String
    case '(S) Sinusoidal'
        handles.LFO.x = handles.LFO.amplitud*sin(2*pi*handles.LFO.frecuencia*handles.LFO.n) + handles.LFO.offset;
    case '(T) Triangular'
        n = 1:floor(L/4);
        i = 1;
        m = -1;
        x(1:floor(L/4)) = 4*handles.LFO.frecuencia*handles.LFO.amplitud*n*Ts + handles.LFO.offset;
        n = -floor(L/4)+1:floor(L/4);
        while i*floor(L/4) < length(handles.LFO.n)
            x(i*floor(L/4)+1:(i+2)*floor(L/4)) = 4*m*handles.LFO.frecuencia*handles.LFO.amplitud*n*Ts + handles.LFO.offset;
            i = i+2;
            m = -m;
        end
        handles.LFO.x = x(1:length(handles.LFO.n));
    case '(DA) Diente sierra ascendente'
        n = 1:floor(L/2);
        i = 1;
        x(1:floor(L/2)) = 2*handles.LFO.frecuencia*handles.LFO.amplitud*n*Ts + handles.LFO.offset;
        n = -floor(L/2)+1:floor(L/2);
        while i*floor(L/2) < length(handles.LFO.n)
            x(i*floor(L/2)+1:(i+2)*floor(L/2)) = 2*handles.LFO.frecuencia*handles.LFO.amplitud*n*Ts + handles.LFO.offset;
            i = i+2;
        end
        handles.LFO.x = x(1:length(handles.LFO.n));
    case '(DD) Diente sierra descendente'
        n = 1:floor(L/2);
        i = 1;
        x(1:floor(L/2)) = -2*handles.LFO.frecuencia*handles.LFO.amplitud*n*Ts + handles.LFO.offset;
        n = -floor(L/2)+1:floor(L/2);
        while i*floor(L/2) < length(handles.LFO.n)
            x(i*floor(L/2)+1:(i+2)*floor(L/2)) = -2*handles.LFO.frecuencia*handles.LFO.amplitud*n*Ts + handles.LFO.offset;
            i = i+2;
        end
        handles.LFO.x = x(1:length(handles.LFO.n));
end
plot(handles.graf,handles.LFO.n,handles.LFO.x)
xlabel(handles.graf,'Tiempo [s]')
set(handles.graf,'XLim',[0 handles.limites.longitud])
set(handles.graf,'YLim',[handles.limites.Min handles.limites.Max])