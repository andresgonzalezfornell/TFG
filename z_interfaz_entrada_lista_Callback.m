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
                    % Mono
                    if length(handles.x(1,:)) == 1
                        x(:,2) = 0;
                    end
                    plot(handles.entrada_L,t,handles.x(:,1),'green')
                    plot(handles.entrada_R,t,handles.x(:,2),'red')
                    X_L = fft(handles.x(:,1))/length(n);
                    X_R = fft(handles.x(:,2))/length(n);
                    handles.X_L = X_L(1:length(n)/2);
                    handles.X_R = X_R(1:length(n)/2);
                    %handles.X = (handles.X_L+handles.X_R)/2;
                    hold(handles.entrada_espectro,'on')
                    stairs(handles.entrada_espectro,f,abs(handles.X_R),'red')
                    stairs(handles.entrada_espectro,f,abs(handles.X_L),'green')
                    set(handles.entrada_espectro,'color',[0.05 0.05 0.1])
                    hold(handles.entrada_espectro,'off')
                    xlabel(handles.entrada_L,'Tiempo [s] (canal L)')
                    xlabel(handles.entrada_R,'Tiempo [s] (canal R)')
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