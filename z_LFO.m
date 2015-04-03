function [handles] = z_LFO(handles,par)
%LFO Control del LFO
switch par
    case 1
        checkbox = get(handles.par_1_LFO,'Value');
    case 2
        checkbox = get(handles.par_2_LFO,'Value');
    case 3
        checkbox = get(handles.par_3_LFO,'Value');
    case 4
        checkbox = get(handles.par_4_LFO,'Value');
    case 5
        checkbox = get(handles.par_5_LFO,'Value');
    case 6
        checkbox = get(handles.par_6_LFO,'Value');
end
checkbox
if checkbox
    LFO = z_LFO_GUI(par,handles.par_limites(par));
    LFO
    if LFO.submit
        switch par
            case 1
                set(handles.par_1,'Enable','off')
                set(handles.par_1_value,'Enable','off')
                set(handles.par_1_value,'String',strcat('[',num2str(LFO.offset-LFO.amplitud,2),',',num2str(LFO.offset+LFO.amplitud,2),'] f = ',num2str(LFO.frecuencia,2),'Hz'));
            case 2
                checkbox = set(handles.par_2_LFO,'Value');
            case 3
                checkbox = set(handles.par_3_LFO,'Value');
            case 4
                checkbox = set(handles.par_4_LFO,'Value');
            case 5
                checkbox = set(handles.par_5_LFO,'Value');
            case 6
                checkbox = set(handles.par_6_LFO,'Value');
        end
        close(z_LFO_GUI())
    else
        switch par
            case 1
                set(handles.par_1_LFO,'Value',0);
            case 2
                checkbox = set(handles.par_2_LFO,'Value');
            case 3
                checkbox = set(handles.par_3_LFO,'Value');
            case 4
                checkbox = set(handles.par_4_LFO,'Value');
            case 5
                checkbox = set(handles.par_5_LFO,'Value');
            case 6
                checkbox = set(handles.par_6_LFO,'Value');
        end
    end
else
    switch par
        case 1
            set(handles.par_1_value,'String',get(handles.par_1,'Value'))
            set(handles.par_1,'Enable','on')
            set(handles.par_1_value,'Enable','off')
            close(z_LFO_GUI)
        case 2
            checkbox = set(handles.par_2_LFO,'Value');
        case 3
            checkbox = set(handles.par_3_LFO,'Value');
        case 4
            checkbox = set(handles.par_4_LFO,'Value');
        case 5
            checkbox = set(handles.par_5_LFO,'Value');
        case 6
            checkbox = set(handles.par_6_LFO,'Value');
    end
end
end

