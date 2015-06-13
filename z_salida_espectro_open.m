%% Ampliación del grafico del espectro de salida

if isfield(handles,'Y_L') && isfield(handles,'Y_R')
    figure('name','Salida espectro')
    n = [1:length(handles.y(:,1))];
    f = 0+handles.fs/length(n):handles.fs/length(n):handles.fs/2;
    hold on
    subplot(2,1,1)
    spectrogram(handles.x(:,1),64,60,64,handles.fs,'yaxis')
    xlabel('Tiempo [s]')
    ylabel('Frecuencia [kHz]')
    set(gca,'YScale','log','XTickMode','manual','YTick',[2 20 200 2000 20000])
    view(160,30)
    shading interp
    colorbar off
    grid on
    subplot(2,1,2)
    spectrogram(handles.x(:,2),64,60,64,handles.fs,'yaxis')
    xlabel('Tiempo [s]')
    ylabel('Frecuencia [kHz]')
    set(gca,'YScale','log','XTickMode','manual','YTick',[2 20 200 2000 20000])
    view(160,30)
    shading interp
    colorbar off
    grid on
    hold off
end