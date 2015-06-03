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
frecuencia(1:length(handles.LFO.n)) = handles.LFO.frecuencia;
amplitud(1:length(handles.LFO.n)) = handles.LFO.amplitud;
offset = handles.LFO.offset;
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
        length(amplitud)
        length(handles.LFO.n)
        length(frecuencia)
        handles.LFO.x = amplitud.*sin(2.*pi.*frecuencia.*handles.LFO.n) + offset;
    case '(T) Triangular'
        n = 0;
        m = 1;
        for i = 1:length(handles.LFO.n)
            handles.LFO.x(i) = 4*amplitud(i)*frecuencia(i)*n*Ts + offset;
            if mod(i+floor(L/4),floor(L/2)) == 0
                m = -m;
            end
            n = n+m;
        end
    case '(DA) Diente sierra asc'
        n = - floor(L/2);
        for i = 1:length(handles.LFO.n)
            handles.LFO.x(i) = 2*amplitud(i)*frecuencia(i)*n*Ts + offset;
            if mod(i,L) == 0
                n = - floor(L/2);
            end
            n = n+1;
        end
    case '(DD) Diente sierra desc'
        n = floor(L/2);
        for i = 1:length(handles.LFO.n)
            handles.LFO.x(i) = 2*amplitud(i)*frecuencia(i)*n*Ts + offset;
            if mod(i,L) == 0
                n = floor(L/2);
            end
            n = n-1;
        end
    case '(C) Cuadrada'
        m = 1;
        j = 1;
        for i = 1:length(handles.LFO.n)
            L = floor(1/(2*Ts*frecuencia(i)));
            if j > L
                m = -m;
                j = 1;
            else
                j = j+1;
            end
            handles.LFO.x(i) = m*amplitud(i) + offset;
        end
    case '(N) Ruido AWGN'
        handles.LFO.x = amplitud.*randn(length(handles.LFO.n),1)/2 + offset;
        for n = 1:length(handles.LFO.n)
            if handles.LFO.x(n) < handles.limites.Min
                handles.LFO.x(n) = handles.limites.Min;
            elseif handles.LFO.x(n) > handles.limites.Max
                handles.LFO.x(n) = handles.limites.Max;                
            end
        end
    case 'Externa'
        [filename path] = uigetfile({'Audios/*'}, 'Select File');           % Use open for other file types.
        b = strfind(filename,'.');
        format = filename(b(end)+1:end);
        if strcmp(format,'wav')             % Si el formato es wav
            file = importdata(strcat(path,'/',filename));
        elseif strcmp(format,'mp3')         % Si el formato es mp3
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
end
if isfield(handles,'frecuencia_LFO') && isfield(handles,'amplitud_LFO')
    if strcmp(tipo.String,'Externa')
        set(handles.frecuencia,'Visible','Off')
        set(handles.frecuencia_value,'Visible','Off')
        set(handles.frecuencia_LFO,'Visible','Off')
        set(handles.frecuencia_title,'Visible','Off')
        set(handles.amplitud,'Visible','Off')
        set(handles.amplitud_value,'Visible','Off')
        set(handles.amplitud_LFO,'Visible','Off')
        set(handles.amplitud_title,'Visible','Off')
        set(handles.offset,'Visible','Off')
        set(handles.offset_value,'Visible','Off')
        set(handles.offset_title,'Visible','Off')
    else
        set(handles.frecuencia,'Visible','On')
        set(handles.frecuencia_value,'Visible','On')
        set(handles.frecuencia_LFO,'Visible','On')
        set(handles.frecuencia_title,'Visible','On')
        set(handles.amplitud,'Visible','On')
        set(handles.amplitud_value,'Visible','On')
        set(handles.amplitud_LFO,'Visible','On')
        set(handles.amplitud_title,'Visible','On')
        set(handles.offset,'Visible','On')
        set(handles.offset_value,'Visible','On')
        set(handles.offset_title,'Visible','On')
    end
end
plot(handles.graf,handles.LFO.n,handles.LFO.x)
xlabel(handles.graf,'Tiempo [s]')
set(handles.graf,'XLim',[0 handles.limites.longitud])
set(handles.graf,'YLim',[handles.limites.Min handles.limites.Max])