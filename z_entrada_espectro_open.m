%% Ampliacion del grafico del espectro de entrada

if isfield(handles,'X_L') && isfield(handles,'X_R')
    figure('name','Espectrograma de entrada')
    n = [1:length(handles.x(:,1))];
    f = 0+handles.fs/length(n):handles.fs/length(n):handles.fs/2;
    hold on
    subplot(2,1,1)
	spectrogram(handles.x(:,1),250,200,250,handles.fs,'yaxis')
    xlabel('Tiempo [s]')
    ylabel('Frecuencia [kHz]')
    set(gca,'YScale','log','XTickMode','manual','YTick',[2 20 200 2000 20000])
    view(160,30)
    shading interp
    colorbar off
    grid on
    subplot(2,1,2)
    spectrogram(handles.x(:,2),250,200,250,handles.fs,'yaxis')
    xlabel('Tiempo [s]')
    ylabel('Frecuencia [kHz]')
    set(gca,'YScale','log','XTickMode','manual','YTick',[2 20 200 2000 20000])
    view(160,30)
    shading interp
    colorbar off
    grid on
    hold off
end