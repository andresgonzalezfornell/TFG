function [handles] = z_LFO(handles,par)
%LFO Control del LFO

% Obtencion del estado del LFO
switch par
    case 0
        handles.LFO_0.checkbox = get(handles.entrada_oscilador,'Value');
        checkbox = handles.LFO_0.checkbox;
    case 1
        handles.LFO_1.checkbox = get(handles.par_1_LFO,'Value');
        checkbox = handles.LFO_1.checkbox;
    case 2
        handles.LFO_2.checkbox = get(handles.par_2_LFO,'Value');
        checkbox = handles.LFO_2.checkbox;
    case 3
        handles.LFO_3.checkbox = get(handles.par_3_LFO,'Value');
        checkbox = handles.LFO_3.checkbox;
    case 4
        handles.LFO_4.checkbox = get(handles.par_4_LFO,'Value');
        checkbox = handles.LFO_4.checkbox;
    case 5
        handles.LFO_5.checkbox = get(handles.par_5_LFO,'Value');
        checkbox = handles.LFO_5.checkbox;
    case 6
        handles.LFO_6.checkbox = get(handles.par_6_LFO,'Value');
        checkbox = handles.LFO_6.checkbox;
end
if checkbox        % Si LFO habilitado
    switch par
        case 0
            limites.Min = -1;
            limites.Max = 1;
            limites.longitud = str2double(get(handles.entrada_length,'String'));
            handles.LFO_0 = z_LFO_GUI(par,limites,44100);
            LFO = handles.LFO_0;
        case 1
            handles.LFO_1 = z_LFO_GUI(par,handles.limites(par),handles.fs);
            LFO = handles.LFO_1;
        case 2
            handles.LFO_2 = z_LFO_GUI(par,handles.limites(par),handles.fs);
            LFO = handles.LFO_2;
        case 3
            handles.LFO_3 = z_LFO_GUI(par,handles.limites(par),handles.fs);
            LFO = handles.LFO_3;
        case 4
            handles.LFO_4 = z_LFO_GUI(par,handles.limites(par),handles.fs);
            LFO = handles.LFO_4;
        case 5
            handles.LFO_5 = z_LFO_GUI(par,handles.limites(par),handles.fs);
            LFO = handles.LFO_5;
        case 6
            handles.LFO_6 = z_LFO_GUI(par,handles.limites(par),handles.fs);
            LFO = handles.LFO_6;
    end
    if LFO.submit       % Si se ha seleccionado a aplicar
        indicador = LFO_indicador(LFO);
        switch par
            case 0
                % Limpieza de variables
                if isfield(handles,'x')
                    clear handles.x
                end
                x(:,1) = handles.LFO_0.x;
                x(:,2) = handles.LFO_0.x;
                handles.x = x;
                handles.fs = 44100;
                z_entrada
                handles.LFO_0.checkbox = 1;
                set(handles.entrada_archivo,'String',indicador)
                % LFO
                handles.LFO_0.checkbox = 0;
                handles.LFO_1.checkbox = 0;
                handles.LFO_2.checkbox = 0;
                handles.LFO_3.checkbox = 0;
                handles.LFO_4.checkbox = 0;
                handles.LFO_5.checkbox = 0;
                handles.LFO_6.checkbox = 0;
                set(handles.par_1,'Enable','on')
                set(handles.par_2,'Enable','on')
                set(handles.par_3,'Enable','on')
                set(handles.par_4,'Enable','on')
                set(handles.par_5,'Enable','on')
                set(handles.par_6,'Enable','on')
                set(handles.par_1_value,'Enable','on','String',get(handles.par_1,'Value'))
                set(handles.par_2_value,'Enable','on','String',get(handles.par_2,'Value'))
                set(handles.par_3_value,'Enable','on','String',get(handles.par_3,'Value'))
                set(handles.par_4_value,'Enable','on','String',get(handles.par_4,'Value'))
                set(handles.par_5_value,'Enable','on','String',get(handles.par_5,'Value'))
                set(handles.par_6_value,'Enable','on','String',get(handles.par_6,'Value'))
                set(handles.par_1_LFO,'Enable','on','Value',0)
                set(handles.par_2_LFO,'Enable','on','Value',0)
                set(handles.par_3_LFO,'Enable','on','Value',0)
                set(handles.par_4_LFO,'Enable','on','Value',0)
                set(handles.par_5_LFO,'Enable','on','Value',0)
                set(handles.par_6_LFO,'Enable','on','Value',0)
            case 1
                handles.LFO_1.checkbox = 1;
                set(handles.par_1,'Enable','off')
                set(handles.par_1_value,'Enable','off')
                set(handles.par_1_value,'String',indicador)
            case 2
                handles.LFO_2.checkbox = 1;
                handles.LFO_N = length(handles.LFO_2.x);
                set(handles.par_2,'Enable','off')
                set(handles.par_2_value,'Enable','off')
                set(handles.par_2_value,'String',indicador)
            case 3
                handles.LFO_3.checkbox = 1;
                handles.LFO_N = length(handles.LFO_3.x);
                set(handles.par_3,'Enable','off')
                set(handles.par_3_value,'Enable','off')
                set(handles.par_3_value,'String',indicador)
            case 4
                handles.LFO_4.checkbox = 1;
                handles.LFO_N = length(handles.LFO_4.x);
                set(handles.par_4,'Enable','off')
                set(handles.par_4_value,'Enable','off')
                set(handles.par_4_value,'String',indicador)
            case 5
                handles.LFO_5.checkbox = 1;
                handles.LFO_N = length(handles.LFO_5.x);
                set(handles.par_5,'Enable','off')
                set(handles.par_5_value,'Enable','off')
                set(handles.par_5_value,'String',indicador)
            case 6
                handles.LFO_6.checkbox = 1;
                handles.LFO_N = length(handles.LFO_6.x);
                set(handles.par_6,'Enable','off')
                set(handles.par_6_value,'Enable','off')
                set(handles.par_6_value,'String',indicador)
        end
    else        % Si se ha seleccionado cancelar
        switch par
            case 0
                handles.LFO_0.checkbox = 0;
                set(handles.entrada_oscilador,'Value',0);
            case 1
                handles.LFO_1.checkbox = 0;
                set(handles.par_1_LFO,'Value',0);
            case 2
                handles.LFO_2.checkbox = 0;
                set(handles.par_2_LFO,'Value',0);
            case 3
                handles.LFO_3.checkbox = 0;
                set(handles.par_3_LFO,'Value',0);
            case 4
                handles.LFO_4.checkbox = 0;
                set(handles.par_4_LFO,'Value',0);
            case 5
                handles.LFO_5.checkbox = 0;
                set(handles.par_5_LFO,'Value',0);
            case 6
                handles.LFO_6.checkbox = 0;
                set(handles.par_6_LFO,'Value',0);
        end
    end
    
else                                % Si LFO deshabilitado
    switch par
        case 0
            if isfield(handles,'x')
                clear handles.x
                cla(handles.entrada_espectro)
            end
            if isfield(handles,'y')
                clear handles.y
                cla(handles.salida_L)
                cla(handles.salida_R)
                cla(handles.salida_espectro)
            end
            handles.LFO_0.checkbox = 0;
            handles.LFO_1.checkbox = 0;
            handles.LFO_2.checkbox = 0;
            handles.LFO_3.checkbox = 0;
            handles.LFO_4.checkbox = 0;
            handles.LFO_5.checkbox = 0;
            handles.LFO_6.checkbox = 0;
            set(handles.entrada_archivo,'String','')
            set(handles.par_1_LFO,'Enable','off','Value',0)
            set(handles.par_2_LFO,'Enable','off','Value',0)
            set(handles.par_3_LFO,'Enable','off','Value',0)
            set(handles.par_4_LFO,'Enable','off','Value',0)
            set(handles.par_5_LFO,'Enable','off','Value',0)
            set(handles.par_6_LFO,'Enable','off','Value',0)
        case 1
            handles.LFO_1.checkbox = 0;
            set(handles.par_1_value,'String',get(handles.par_1,'Value'))
            set(handles.par_1,'Enable','on')
            set(handles.par_1_value,'Enable','on')
        case 2
            handles.LFO_2.checkbox = 0;
            set(handles.par_2_value,'String',get(handles.par_2,'Value'))
            set(handles.par_2,'Enable','on')
            set(handles.par_2_value,'Enable','on')
        case 3
            handles.LFO_3.checkbox = 0;
            set(handles.par_3_value,'String',get(handles.par_3,'Value'))
            set(handles.par_3,'Enable','on')
            set(handles.par_3_value,'Enable','on')
        case 4
            handles.LFO_4.checkbox = 0;
            set(handles.par_4_value,'String',get(handles.par_4,'Value'))
            set(handles.par_4,'Enable','on')
            set(handles.par_4_value,'Enable','on')
        case 5
            handles.LFO_5.checkbox = 0;
            set(handles.par_5_value,'String',get(handles.par_5,'Value'))
            set(handles.par_5,'Enable','on')
            set(handles.par_5_value,'Enable','on')
        case 6
            handles.LFO_6.checkbox = 0;
            set(handles.par_6_value,'String',get(handles.par_6,'Value'))
            set(handles.par_6,'Enable','on')
            set(handles.par_6_value,'Enable','on')
    end
end
end

function [indicador] = LFO_indicador(LFO)
    switch LFO.tipo
        case '(S) Sinusoidal'
            indicador = '(S)';
        case '(T) Triangular'
            indicador = '(T)';
        case '(DA) Diente sierra asc'
            indicador = '(DA)';
        case '(DD) Diente sierra desc'
            indicador = '(DD)';
        case '(C) Cuadrada'
            indicador = '(C)';
        case '(N) Ruido AWGN'
            indicador = '(N)';
        case 'Externa'
            indicador = 'Externa';
    end
    if isfield(LFO.modulador(1),'tipo')
        if ischar(LFO.modulador(1).tipo)
            switch LFO.modulador(1).tipo
                case '(S) Sinusoidal'
                    modulador1_tipo = '(S)';
                case '(T) Triangular'
                    modulador1_tipo = '(T)';
                case '(DA) Diente sierra asc'
                    modulador1_tipo = '(DA)';
                case '(DD) Diente sierra desc'
                    modulador1_tipo = '(DD)';
                case '(C) Cuadrada'
                    modulador1_tipo = '(C)';
                case '(N) Ruido AWGN'
                    modulador1_tipo = '(N)';
                case 'Externa'
                    modulador1_tipo = 'Externa';
            end
        end
    end
    if isfield(LFO.modulador(2),'tipo')
        if ischar(LFO.modulador(2).tipo)
            switch LFO.modulador(2).tipo
                case '(S) Sinusoidal'
                    modulador2_tipo = '(S)';
                case '(T) Triangular'
                    modulador2_tipo = '(T)';
                case '(DA) Diente sierra asc'
                    modulador2_tipo = '(DA)';
                case '(DD) Diente sierra desc'
                    modulador2_tipo = '(DD)';
                case '(C) Cuadrada'
                    modulador2_tipo = '(C)';
                case '(N) Ruido AWGN'
                    modulador2_tipo = '(N)';
                case 'Externa'
                    modulador2_tipo = 'Externa';
            end
        end
    end
    if isfield(LFO.modulador(3),'tipo')
        if ischar(LFO.modulador(3).tipo)
            switch LFO.modulador(3).tipo
                case '(S) Sinusoidal'
                    modulador3_tipo = '(S)';
                case '(T) Triangular'
                    modulador3_tipo = '(T)';
                case '(DA) Diente sierra asc'
                    modulador3_tipo = '(DA)';
                case '(DD) Diente sierra desc'
                    modulador3_tipo = '(DD)';
                case '(C) Cuadrada'
                    modulador3_tipo = '(C)';
                case '(N) Ruido AWGN'
                    modulador3_tipo = '(N)';
                case 'Externa'
                    modulador3_tipo = 'Externa';
            end
        end
    end
    if ~strcmp(LFO.tipo,'Externa')
        if LFO.modulador(1).checkbox
            indicador = strcat(indicador,' FM ',modulador1_tipo);
        else
            indicador = strcat(indicador,' f = ',num2str(LFO.frecuencia,2),'Hz');
        end
        if LFO.modulador(2).checkbox
            indicador = strcat(indicador,' AM ',modulador2_tipo);
        else
            indicador = strcat(indicador,' [',num2str(LFO.offset-LFO.amplitud,2),',',num2str(LFO.offset+LFO.amplitud,2),']');
        end
        if LFO.modulador(3).checkbox
            indicador = strcat(indicador,' PM ',modulador3_tipo);
        end
    end
end