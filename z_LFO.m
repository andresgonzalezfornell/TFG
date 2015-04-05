function [handles] = z_LFO(handles,par)
%LFO Control del LFO

% Obtención del estado del LFO
switch par
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
        case 1
            handles.LFO_1 = z_LFO_GUI(par,handles.limites(par));
            LFO = handles.LFO_1;
        case 2
            handles.LFO_2 = z_LFO_GUI(par,handles.limites(par));
            LFO = handles.LFO_2;
        case 3
            handles.LFO_3 = z_LFO_GUI(par,handles.limites(par));
            LFO = handles.LFO_3;
        case 4
            handles.LFO_4 = z_LFO_GUI(par,handles.limites(par));
            LFO = handles.LFO_4;
        case 5
            handles.LFO_5 = z_LFO_GUI(par,handles.limites(par));
            LFO = handles.LFO_5;
        case 6
            handles.LFO_6 = z_LFO_GUI(par,handles.limites(par));
            LFO = handles.LFO_6;
    end
    if LFO.submit       % Si se ha seleccionado a aplicar
        switch LFO.tipo
            case '(S) Sinusoidal'
                tipo_abreviado = '(S)';
            case '(T) Triangular'
                tipo_abreviado = '(T)';
            case '(DA) Diente sierra ascendente'
                tipo_abreviado = '(DA)';
            case '(DD) Diente sierra descendente'
                tipo_abreviado = '(DD)';
        end
        switch par
            case 1
                handles.LFO_1.checkbox = 1;
                set(handles.par_1,'Enable','off')
                set(handles.par_1_value,'Enable','off')
                set(handles.par_1_value,'String',strcat(tipo_abreviado,...
                    ' [',num2str(LFO.offset-LFO.amplitud,2),...
                    ',',num2str(LFO.offset+LFO.amplitud,2),...
                    '] f = ',num2str(LFO.frecuencia,2),...
                    'Hz'))
            case 2
                handles.LFO_2.checkbox = 1;
                set(handles.par_2,'Enable','off')
                set(handles.par_2_value,'Enable','off')
                set(handles.par_2_value,'String',strcat(tipo_abreviado,...
                    ' [',num2str(LFO.offset-LFO.amplitud,2),...
                    ',',num2str(LFO.offset+LFO.amplitud,2),...
                    '] f = ',num2str(LFO.frecuencia,2),...
                    'Hz'))
            case 3
                handles.LFO_3.checkbox = 1;
                set(handles.par_3,'Enable','off')
                set(handles.par_3_value,'Enable','off')
                set(handles.par_3_value,'String',strcat(tipo_abreviado,...
                    ' [',num2str(LFO.offset-LFO.amplitud,2),...
                    ',',num2str(LFO.offset+LFO.amplitud,2),...
                    '] f = ',num2str(LFO.frecuencia,2),...
                    'Hz'))
            case 4
                handles.LFO_4.checkbox = 1;
                set(handles.par_4,'Enable','off')
                set(handles.par_4_value,'Enable','off')
                set(handles.par_4_value,'String',strcat(tipo_abreviado,...
                    ' [',num2str(LFO.offset-LFO.amplitud,2),...
                    ',',num2str(LFO.offset+LFO.amplitud,2),...
                    '] f = ',num2str(LFO.frecuencia,2),...
                    'Hz'))
            case 5
                handles.LFO_5.checkbox = 1;
                set(handles.par_5,'Enable','off')
                set(handles.par_5_value,'Enable','off')
                set(handles.par_5_value,'String',strcat(tipo_abreviado,...
                    ' [',num2str(LFO.offset-LFO.amplitud,2),...
                    ',',num2str(LFO.offset+LFO.amplitud,2),...
                    '] f = ',num2str(LFO.frecuencia,2),...
                    'Hz'))
            case 6
                handles.LFO_6.checkbox = 1;
                set(handles.par_6,'Enable','off')
                set(handles.par_6_value,'Enable','off')
                set(handles.par_6_value,'String',strcat(tipo_abreviado,...
                    ' [',num2str(LFO.offset-LFO.amplitud,2),...
                    ',',num2str(LFO.offset+LFO.amplitud,2),...
                    '] f = ',num2str(LFO.frecuencia,2),...
                    'Hz'))
        end
    else        % Si se ha seleccionado cancelar
        switch par
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
        case 1
            handles.LFO_1.checkbox = 0;
            set(handles.par_1_value,'String',get(handles.par_1,'Value'))
            set(handles.par_1,'Enable','on')
            set(handles.par_1_value,'Enable','on')
        case 2
            handles.LFO_2.checkbox = 0;
            set(handles.par_2_value,'String',get(handles.par_1,'Value'))
            set(handles.par_2,'Enable','on')
            set(handles.par_2_value,'Enable','on')
        case 3
            handles.LFO_3.checkbox = 0;
            set(handles.par_3_value,'String',get(handles.par_1,'Value'))
            set(handles.par_3,'Enable','on')
            set(handles.par_3_value,'Enable','on')
        case 4
            handles.LFO_4.checkbox = 0;
            set(handles.par_4_value,'String',get(handles.par_1,'Value'))
            set(handles.par_4,'Enable','on')
            set(handles.par_4_value,'Enable','on')
        case 5
            handles.LFO_5.checkbox = 0;
            set(handles.par_5_value,'String',get(handles.par_1,'Value'))
            set(handles.par_5,'Enable','on')
            set(handles.par_5_value,'Enable','on')
        case 6
            handles.LFO_6.checkbox = 0;
            set(handles.par_6_value,'String',get(handles.par_1,'Value'))
            set(handles.par_6,'Enable','on')
            set(handles.par_6_value,'Enable','on')
    end
end
end

