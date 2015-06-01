function [modulador] = z_modulador(handles,par)
%z_moduladors Control del modulador del LFO

% Obtencion del estado del LFO
switch par
    case 1
        modulador.LFO_frecuencia.checkbox = get(handles.frecuencia_LFO,'Value');
        checkbox = modulador.LFO_frecuencia.checkbox;
    case 2
        modulador.LFO_amplitud.checkbox = get(handles.amplitud_LFO,'Value');
        checkbox = modulador.LFO_amplitud.checkbox;
end
if checkbox        % Si LFO habilitado
    limites.longitud = handles.limites.longitud;
    switch par
        case 1
            limites.Min = handles.LFO.frecuencia_Min;
            limites.Max = handles.LFO.frecuencia_Max;
        case 2
            limites.Min = handles.LFO.amplitud_Min;
            limites.Max = handles.LFO.amplitud_Max;
    end
    modulador = z_modulador_GUI(par,limites,handles.fs);
    if modulador.submit       % Si se ha seleccionado a aplicar
        modulador.checkbox = 1;
        switch modulador.tipo
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
                        ' [',num2str(handles.LFO.offset-modulador.amplitud,2),...
                        ',',num2str(handles.LFO.offset+modulador.amplitud,2),...
                        '] f = ',num2str(modulador.frecuencia,2),...
                        'Hz'))
                end
            case 2
                set(handles.amplitud,'Enable','off')
                set(handles.amplitud_value,'Enable','off')
                if strcmp(tipo_abreviado,'Externa')
                    set(handles.amplitud_value,'String',tipo_abreviado)
                else
                    set(handles.amplitud_value,'String',strcat(tipo_abreviado,...
                        ' [',num2str(handles.LFO.offset-modulador.amplitud,2),...
                        ',',num2str(handles.LFO.offset+modulador.amplitud,2),...
                        '] f = ',num2str(modulador.frecuencia,2),...
                        'Hz'))
                end
        end
    else        % Si se ha seleccionado cancelar
        modulador.checkbox = 0;
        switch par
            case 1
                set(handles.frecuencia_LFO,'Value',0);
            case 2
                set(handles.amplitud_LFO,'Value',0);
        end
    end
else                                % Si LFO deshabilitado
    modulador.checkbox = 0;
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
