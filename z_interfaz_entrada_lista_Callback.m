%% Acciones de navegacion entre directorios

% Navegacion de directorios
get(handles.figure1,'SelectionType');
% If double click
if strcmp(get(handles.figure1,'SelectionType'),'open')
    index_selected = get(handles.entrada_lista,'Value');
    file_list = get(handles.entrada_lista,'String');
    % Item selected in list box
    filename = file_list{index_selected};
    % If folder
    if  handles.is_dir(handles.sorted_index(index_selected))
        if strcmp(filename,'.')
        elseif strcmp(filename,'..')
            a = strfind(handles.path,'/');
            if isempty(a)
                a = strfind(handles.path,'\');
            end
            if length(strfind(handles.path,'/')) + length(strfind(handles.path,'\')) > 1
                handles.path = handles.path(1:a(end)-1);
            end
        else
            handles.path = strcat(handles.path,'/',filename);
        end
        % Load list box with new folder.
        % Cargador de ficheros de entrada
        dir_struct = dir(handles.path);
        [sorted_names,sorted_index] = sortrows({dir_struct.name}');
        handles.file_names = sorted_names;
        handles.is_dir = [dir_struct.isdir];
        handles.sorted_index = sorted_index;
        guidata(handles.figure1,handles)
        set(handles.entrada_lista,'String',handles.file_names,...
            'Value',1)
        set(handles.directorio,'String',handles.path)
    % If file
    else
        [path,name,ext] = fileparts(filename);
        switch ext
            case '.fig'
                % Open FIG-file with guide command.
                guide (filename)
            otherwise
                wb = waitbar(0,'Cargando audio...','Name','Audio de entrada');
                set(handles.play_entrada,'Enable','Off')
                set(handles.stop_entrada,'Enable','Off')
                set(handles.pause_entrada,'Enable','Off')
                try
                    % Use open for other file types.
                    b = strfind(filename,'.');
                    format = filename(b(end)+1:end);
                    waitbar(1/4,wb,'Cargando audio...');
                    % Si el formato es wav
                    if strcmp(format,'wav')
                        file = importdata(strcat(handles.path,'/',filename));
                    % Si el formato es mp3
                    elseif strcmp(format,'mp3')
                        [file.data, file.fs] = audioread(strcat(handles.path,'/',filename));
                    end
                    waitbar(2/4,wb,'Cargando audio...','Name','Audio de entrada');
                    handles.x = file.data;
                    handles.fs = file.fs;
                    z_entrada
                    waitbar(3/4,wb,'Cargando audio...','Name','Audio de entrada');
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
                    set(handles.par_1_value,'String',get(handles.par_1,'Value'),'Enable','on')
                    set(handles.par_2_value,'String',get(handles.par_2,'Value'),'Enable','on')
                    set(handles.par_3_value,'String',get(handles.par_3,'Value'),'Enable','on')
                    set(handles.par_4_value,'String',get(handles.par_4,'Value'),'Enable','on')
                    set(handles.par_5_value,'String',get(handles.par_5,'Value'),'Enable','on')
                    set(handles.par_6_value,'String',get(handles.par_6,'Value'),'Enable','on')
                    set(handles.entrada_oscilador,'Enable','on','Value',0)
                    set(handles.par_1_LFO,'Enable','on','Value',0)
                    set(handles.par_2_LFO,'Enable','on','Value',0)
                    set(handles.par_3_LFO,'Enable','on','Value',0)
                    set(handles.par_4_LFO,'Enable','on','Value',0)
                    set(handles.par_5_LFO,'Enable','on','Value',0)
                    set(handles.par_6_LFO,'Enable','on','Value',0) 
                    waitbar(4/4,wb,'Cargando audio...','Name','Audio de entrada');
                    set(handles.entrada_archivo,'String',filename)
                    set(handles.entrada_length,'String',length(handles.x(:,1))/handles.fs)
                    % Dialogo de espera
                    if exist('wb')
                        close(wb)
                    end
                    set(handles.play_entrada,'Enable','On')
                    set(handles.stop_entrada,'Enable','On')
                    set(handles.pause_entrada,'Enable','On')
                catch ex
                    errordlg(...
                      ex.getReport('basic'),'File Type Error','modal')
                end
        end
    end
end


% Update handles structure
guidata(hObject, handles);