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
frecuencia = handles.LFO.frecuencia;
amplitud = handles.LFO.amplitud;
% Modulador
if isfield(handles,'modulador')
    if handles.modulador.LFO_frecuencia.checkbox || handles.modulador.LFO_amplitud.checkbox
        LFO_res = 10;
        for n = 0:LFO_res:length(handles.LFO.n)-LFO_res
            if handles.modulador.LFO_frecuencia.checkbox
                frecuencia(n+1:n+LFO_res,1) = handles.modulador.LFO_frecuencia.x(n+1);
            end
            if handles.modulador.LFO_amplitud.checkbox
                amplitud(n+1:n+LFO_res,1) = handles.modulador.LFO_amplitud.x(n+1);
            end
        end
        if handles.modulador.LFO_frecuencia.checkbox
            frecuencia(n+LFO_res+1:length(handles.LFO.n)) = handles.modulador.LFO_frecuencia.x(n+1);
        end
        if handles.modulador.LFO_amplitud.checkbox
            amplitud(n+LFO_res+1:length(handles.LFO.n)) = handles.modulador.LFO_amplitud.x(n+1);
        end
    end
end
switch tipo.String
    case '(S) Sinusoidal'
        length( sin(2.*pi.*frecuencia.*handles.LFO.n))
        length(amplitud)
        handles.LFO.x(1:length(handles.LFO.n)) = amplitud.*sin(2.*pi.*frecuencia.*handles.LFO.n);
        handles.LFO.x = amplitud.*sin(2.*pi.*frecuencia.*handles.LFO.n) + handles.LFO.offset;
        set(handles.frecuencia,'Enable','On')
        set(handles.frecuencia_value,'Enable','On')
        set(handles.amplitud,'Enable','On')
        set(handles.amplitud_value,'Enable','On')
        set(handles.offset,'Enable','On')
        set(handles.offset_value,'Enable','On')
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
        set(handles.frecuencia,'Enable','On')
        set(handles.frecuencia_value,'Enable','On')
        set(handles.amplitud,'Enable','On')
        set(handles.amplitud_value,'Enable','On')
        set(handles.offset,'Enable','On')
        set(handles.offset_value,'Enable','On')
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
        set(handles.frecuencia,'Enable','On')
        set(handles.frecuencia_value,'Enable','On')
        set(handles.amplitud,'Enable','On')
        set(handles.amplitud_value,'Enable','On')
        set(handles.offset,'Enable','On')
        set(handles.offset_value,'Enable','On')
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
        set(handles.frecuencia,'Enable','On')
        set(handles.frecuencia_value,'Enable','On')
        set(handles.amplitud,'Enable','On')
        set(handles.amplitud_value,'Enable','On')
        set(handles.offset,'Enable','On')
        set(handles.offset_value,'Enable','On')
    case '(C) Cuadrada'
        n = 1:floor(L/2);
        i = 1;
        while i*floor(L/2) < length(handles.LFO.n)
            x(n+(2*i-2)*floor(L/2)) = handles.LFO.amplitud + handles.LFO.offset;
            x(n+(2*i-1)*floor(L/2)) = -handles.LFO.amplitud + handles.LFO.offset;
            i = i+1;
        end
        handles.LFO.x = x(1:length(handles.LFO.n));
        set(handles.frecuencia,'Enable','On')
        set(handles.frecuencia_value,'Enable','On')
        set(handles.amplitud,'Enable','On')
        set(handles.amplitud_value,'Enable','On')
        set(handles.offset,'Enable','On')
        set(handles.offset_value,'Enable','On')
    case '(N) Ruido AWGN'
        handles.LFO.x = handles.LFO.amplitud.*randn(length(handles.LFO.n),1)/2 + handles.LFO.offset;
        for n = 1:length(handles.LFO.n)
            if handles.LFO.x(n) < handles.limites.Min
                handles.LFO.x(n) = handles.limites.Min;
            elseif handles.LFO.x(n) > handles.limites.Max
                handles.LFO.x(n) = handles.limites.Max;                
            end
        end
        set(handles.frecuencia,'Enable','On')
        set(handles.frecuencia_value,'Enable','On')
        set(handles.amplitud,'Enable','On')
        set(handles.amplitud_value,'Enable','On')
        set(handles.offset,'Enable','On')
        set(handles.offset_value,'Enable','On')
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
        if length(file.data(:,1)) < length(handles.LFO.n)
            for i = 1:floor(length(handles.LFO.n)/length(file.data(:,1)))
                handles.LFO.x((i-1)*length(file.data)+1:i*length(file.data)) = file.data(:,1);
            end
            handles.LFO.x(i*length(file.data)+1:length(handles.LFO.n)) = file.data(1:length(handles.LFO.n)-i*length(file.data),1);
        else
            handles.LFO.x = file.data(1:length(handles.LFO.n),1);
        end
        handles.LFO.x = (handles.LFO.x+1)*(handles.limites.Max-handles.limites.Min)/2+handles.limites.Min;
        set(handles.frecuencia,'Enable','Off')
        set(handles.frecuencia_value,'Enable','Off')
        set(handles.amplitud,'Enable','Off')
        set(handles.amplitud_value,'Enable','Off')
        set(handles.offset,'Enable','Off')
        set(handles.offset_value,'Enable','Off')
end
plot(handles.graf,handles.LFO.n,handles.LFO.x)
xlabel(handles.graf,'Tiempo [s]')
set(handles.graf,'XLim',[0 handles.limites.longitud])
set(handles.graf,'YLim',[handles.limites.Min handles.limites.Max])