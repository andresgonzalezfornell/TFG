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
handles.LFO.n = transpose(Ts:Ts:handles.limites.longitud);
frecuencia(1:length(handles.LFO.n),1) = handles.LFO.frecuencia;
amplitud(1:length(handles.LFO.n),1) = handles.LFO.amplitud;
offset = handles.LFO.offset;
% Modulador
if isfield(handles.LFO,'modulador')
    anymodulador = 0;
    for i = 1:length(handles.LFO.modulador)
        anymodulador = anymodulador || handles.LFO.modulador(i).checkbox;
    end
    if anymodulador
        LFO_res = 10;
        for n = 0:LFO_res:length(handles.LFO.n)-LFO_res
            if handles.LFO.modulador(1).checkbox        % FM
                frecuencia(n+1:n+LFO_res,1) = handles.LFO.modulador(1).x(n+1);
            end
            if handles.LFO.modulador(2).checkbox        % AM
                amplitud(n+1:n+LFO_res,1) = handles.LFO.modulador(2).x(n+1);
            end
        end
        if handles.LFO.modulador(1).checkbox            % FM ultima vuelta incompleta
            frecuencia(n+LFO_res+1:length(handles.LFO.n)) = handles.LFO.modulador(1).x(n+1);
        end
        if handles.LFO.modulador(2).checkbox            % AM ultima vuelta incompleta
            amplitud(n+LFO_res+1:length(handles.LFO.n)) = handles.LFO.modulador(2).x(n+1);
        end
    end
end
switch tipo.String
    case '(S) Sinusoidal'
        handles.LFO.x = amplitud.*sin(2.*pi.*frecuencia.*handles.LFO.n) + offset;
    case '(T) Triangular'
        m = 1;
        n = 0;
        j = 1;
        k = 0;
        for i = 1:length(handles.LFO.n)
            L = floor(1/(4*Ts*frecuencia(i)));
            if j > L
                if mod(k,2) == 0
                    m = -m;
                    k = 0;
                end
                j = 1;
                k = k+1;
            else
                j = j+1;
            end
            handles.LFO.x(i) = amplitud(i)/L*n + offset;
            n = n+m;
        end
    case '(DA) Diente sierra asc'
        n = -floor(1/(2*Ts*frecuencia(1)));
        j = 1;
        for i = 1:length(handles.LFO.n)
            L = floor(1/(Ts*frecuencia(i)));
            if j > L
                n = -floor(L/2);
                j = 1;
            else
                j = j+1;
            end
            handles.LFO.x(i) = 2*amplitud(i)/L*n + offset;
            n = n+1;
        end
    case '(DD) Diente sierra desc'
        n = -floor(1/(2*Ts*frecuencia(1)));
        j = 1;
        for i = 1:length(handles.LFO.n)
            L = floor(1/(Ts*frecuencia(i)));
            if j > L
                n = -floor(L/2);
                j = 1;
            else
                j = j+1;
            end
            handles.LFO.x(i) = -2*amplitud(i)/L*n + offset;
            n = n+1;
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