function [handles] = z_modulador(handles,par)
%z_moduladors Control del modulador del LFO

% Obtencion del estado del LFO
switch par
    case 1
        handles.LFO.modulador(par).checkbox = get(handles.frecuencia_LFO,'Value');
    case 2
        handles.LFO.modulador(par).checkbox = get(handles.amplitud_LFO,'Value');
end

if handles.LFO.modulador(par).checkbox        % Si LFO habilitado
    limites.longitud = handles.limites.longitud;
    switch par
        case 1          % FM
            limites.Min = handles.LFO.frecuencia_Min;
            limites.Max = handles.LFO.frecuencia_Max;
        case 2          % AM
            limites.Min = handles.LFO.amplitud_Min;
            limites.Max = handles.LFO.amplitud_Max;
    end
    LFO = z_modulador_GUI(par,limites,handles.fs);
    field_LFO = fieldnames(LFO);
    for i = 1:length(field_LFO)
        handles.LFO.modulador(par).(field_LFO{i}) = LFO.(field_LFO{i});
    end
    if handles.LFO.modulador(par).submit       % Si se ha seleccionado a aplicar
        handles.LFO.modulador(par).checkbox = 1;
        switch handles.LFO.modulador(par).tipo
            case '(S) Sinusoidal'
                tipo_abreviado = '(S)';
            case '(T) Triangular'
                tipo_abreviado = '(T)';
            case '(DA) Diente sierra asc'
                tipo_abreviado = '(DA)';
            case '(DD) Diente sierra desc'
                tipo_abreviado = '(DD)';
            case '(N) Ruido AWGN'
                tipo_abreviado = '(N)';
            case '(C) Cuadrada'
                tipo_abreviado = '(C)';
            case 'Externa'
                tipo_abreviado = 'Externa';
        end
        switch par
            case 1
                set(handles.frecuencia,'Enable','off')
                set(handles.frecuencia_value,'Enable','off')
                if strcmp(tipo_abreviado,'Externa')
                    set(handles.frecuencia_value,'String',tipo_abreviado)
                else
                    set(handles.frecuencia_value,'String',strcat(tipo_abreviado,...
                        ' [',num2str(handles.LFO.offset-handles.LFO.modulador(par).amplitud,2),...
                        ',',num2str(handles.LFO.offset+handles.LFO.modulador(par).amplitud,2),...
                        '] f = ',num2str(handles.LFO.modulador(par).frecuencia,2),...
                        'Hz'))
                end
            case 2
                set(handles.amplitud,'Enable','off')
                set(handles.amplitud_value,'Enable','off')
                if strcmp(tipo_abreviado,'Externa')
                    set(handles.amplitud_value,'String',tipo_abreviado)
                else
                    set(handles.amplitud_value,'String',strcat(tipo_abreviado,...
                        ' [',num2str(handles.LFO.offset-handles.LFO.modulador(par).amplitud,2),...
                        ',',num2str(handles.LFO.offset+handles.LFO.modulador(par).amplitud,2),...
                        '] f = ',num2str(handles.LFO.modulador(par).frecuencia,2),...
                        'Hz'))
                end
        end
    else        % Si se ha seleccionado cancelar
        handles.LFO.modulador(par).checkbox = 0;
        switch par
            case 1
                set(handles.frecuencia_LFO,'Value',0);
            case 2
                set(handles.amplitud_LFO,'Value',0);
        end
    end
else                                % Si LFO deshabilitado
    handles.LFO.modulador(par).checkbox = 0;
    switch par
        case 1
            set(handles.frecuencia_value,'String',get(handles.frecuencia,'Value'))
            set(handles.frecuencia,'Enable','on')
            set(handles.frecuencia_value,'Enable','on')
        case 2
            set(handles.amplitud_value,'String',get(handles.amplitud,'Value'))
            set(handles.amplitud,'Enable','on')
            set(handles.amplitud_value,'Enable','on')
    end
end
end
