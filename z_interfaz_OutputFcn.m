%% Acciones de devolucion de la salida de la funcion de la interfaz

if isfield(handles,'y')
    y(:,1) = handles.y(:,1);
    y(:,2) = handles.y(:,2);
    y(1:length(handles.Y_L),3) = handles.Y_L;
    y(1:length(handles.Y_R),4) = handles.Y_R;
    y(1:length(handles.Y),5) = handles.Y_R;
    varargout{1} = y;
end