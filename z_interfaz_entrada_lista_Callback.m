%% Acciones de navegación entre directorios

% Navegación de directorios
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
            handles.path = handles.path(1:a(end)-1);
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
                try
                    % Use open for other file types.
                    b = strfind(filename,'.');
                    format = filename(b(end)+1:end);
                    % Si el formato es wav
                    if strcmp(format,'wav')
                        file = importdata(strcat(handles.path,'/',filename));
                    % Si el formato es mp3
                    elseif strcmp(format,'mp3')
                        file.data = audioread(strcat(handles.path,'/',filename)); 
                        file.fs = 44100;
                    end
                    handles.x = file.data;
                    handles.fs = file.fs;
                    handles.x_audio = audioplayer(file.data,file.fs);
                    n = 1:length(handles.x(:,1));
                    t = n/file.fs;
                    f = 0+file.fs/length(n):file.fs/length(n):file.fs/2;
                    
                    % LFO
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
                    set(handles.par_1_LFO,'Enable','on','Value',0)
                    set(handles.par_2_LFO,'Enable','on','Value',0)
                    set(handles.par_3_LFO,'Enable','on','Value',0)
                    set(handles.par_4_LFO,'Enable','on','Value',0)
                    set(handles.par_5_LFO,'Enable','on','Value',0)
                    set(handles.par_6_LFO,'Enable','on','Value',0)
                    for i = 1:6
                        handles.limites(i).longitud = length(handles.x(:,1))/handles.fs;
                    end
                    
                    % Mono
                    if length(handles.x(1,:)) == 1
                        x(:,2) = 0;
                    end
                    X_L = fft(handles.x(:,1))/length(n);
                    X_R = fft(handles.x(:,2))/length(n);
                    handles.X_L = X_L(1:length(n)/2);
                    handles.X_R = X_R(1:length(n)/2);
                    %handles.X = (handles.X_L+handles.X_R)/2;
                    cla(handles.entrada_espectro)
                    hold(handles.entrada_espectro,'on')
                    loglog(handles.entrada_espectro,f,abs(handles.X_R),'red')
                    loglog(handles.entrada_espectro,f,abs(handles.X_L),'green')
                    set(handles.entrada_espectro,'XLim',[20 20000],'XGrid','on')
                    hold(handles.entrada_espectro,'off')
                    xlabel(handles.entrada_espectro,'Frecuencia [Hz]')
                    set(handles.entrada_archivo,'String',filename);
                catch ex
                    errordlg(...
                      ex.getReport('basic'),'File Type Error','modal')
                end
        end
    end
end

% Update handles structure
guidata(hObject, handles);