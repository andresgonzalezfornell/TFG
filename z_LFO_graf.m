%% Creacion y graficacion de las senales de LFO

% Limpieza de variables
if isfield(handles.LFO,'n')
    handles.LFO = rmfield(handles.LFO,'n');
end
if isfield(handles.LFO,'x')
    handles.LFO = rmfield(handles.LFO,'x');
end
tipo = get(handles.tipo_panel,'SelectedObject');
handles.LFO.tipo = tipo.String;
Ts = 1/handles.fs;              % Periodo de muestreo
T = 1/handles.LFO.frecuencia;   % Periodo de senal
L = floor(T/Ts);                % Numero de muestras de un periodo de senal
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
            x(i*floor(L/4)+1:(i+2)*floor(L/4)) = 4*m*handles.LFO.amplitud*handles.LFO.frecuencia*n*Ts + handles.LFO.offset;
            i = i+2;
            m = -m;
        end
        handles.LFO.x = x(1:length(handles.LFO.n));
    case '(DA) Diente sierra asc'
        n = 1:floor(L/2);
        i = 1;
        x(1:floor(L/2)) = 2*handles.LFO.frecuencia*handles.LFO.amplitud*n*Ts + handles.LFO.offset;
        n = -floor(L/2)+1:floor(L/2);
        while i*floor(L/2) < length(handles.LFO.n)
            x(i*floor(L/2)+1:(i+2)*floor(L/2)) = 2*handles.LFO.frecuencia*handles.LFO.amplitud*n*Ts + handles.LFO.offset;
            i = i+2;
        end
        handles.LFO.x = x(1:length(handles.LFO.n));
    case '(DD) Diente sierra desc'
        n = 1:floor(L/2);
        i = 1;
        x(1:floor(L/2)) = -2*handles.LFO.frecuencia*handles.LFO.amplitud*n*Ts + handles.LFO.offset;
        n = -floor(L/2)+1:floor(L/2);
        while i*floor(L/2) < length(handles.LFO.n)
            x(i*floor(L/2)+1:(i+2)*floor(L/2)) = -2*handles.LFO.frecuencia*handles.LFO.amplitud*n*Ts + handles.LFO.offset;
            i = i+2;
        end
        handles.LFO.x = x(1:length(handles.LFO.n));
    case '(C) Cuadrada'
        n = 1:floor(L/2);
        i = 1;
        while i*floor(L/2) < length(handles.LFO.n)
            x(n+(2*i-2)*floor(L/2)) = handles.LFO.amplitud + handles.LFO.offset;
            x(n+(2*i-1)*floor(L/2)) = -handles.LFO.amplitud + handles.LFO.offset;
            i = i+1;
        end
        handles.LFO.x = x(1:length(handles.LFO.n));
    case 'Externa'
        [filename path] = uigetfile({'Audios/*'}, 'Select File');
        % Use open for other file types.
        b = strfind(filename,'.');
        format = filename(b(end)+1:end);
        % Si el formato es wav
        if strcmp(format,'wav')
            file = importdata(strcat(path,'/',filename));
        % Si el formato es mp3
        elseif strcmp(format,'mp3')
            file.data = audioread(strcat(path,'/',filename)); 
            file.fs = 44100;
        end
        if length(file.data) < handles.limites.longitud
            for i = 1:length(handles.LFO.n)\length(file.data)
                handles.LFO.x((i-1)*length(file.data)+1:i*length(file.data)) = file.data;
            end
            handles.LFO.x(i*length(file.data)+1:length(handles.LFO.n)) = file.data;
        else
            handles.LFO.x = file.data(1:length(handles.LFO.n),1);
        end
end
plot(handles.graf,handles.LFO.n,handles.LFO.x)
xlabel(handles.graf,'Tiempo [s]')
set(handles.graf,'XLim',[0 handles.limites.longitud])
set(handles.graf,'YLim',[handles.limites.Min handles.limites.Max])