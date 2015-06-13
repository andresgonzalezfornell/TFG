clear

handles.LFO_1.checkbox = 0;
handles.LFO_2.checkbox = 0;
fs = 44100;
BW = 100;
f_c = 1000;
LFO_res = 10000;


n = 1:fs;
fs = 44100;
x(:,1) = randn(fs,1);
%x(:,1) = 0.5*sin(2*pi*440/fs*n) + 0.5*sin(2*pi*5000/fs*n);
x(:,2) = x(:,1);
audioin = audioplayer(x,fs);
X = fft(x)/length(n);

% Filto banda eliminada
y = zeros(length(x(:,1)),2);
% Inicializacion de memorias
xh = zeros(2,2,3);
ap_y = zeros(1,2,3);
% Coeficientes
c(1) = (tan(pi*BW/fs)-1) / (tan(pi*BW/fs)+1);
c(2) = (tan(pi*BW/fs)-1) / (tan(pi*BW/fs)+1);
c(3) = (tan(pi*BW/fs)-1) / (tan(pi*BW/fs)+1);
d(1) = -cos(2*pi*f_c/2/fs);
d(2) = -cos(2*pi*f_c/fs);
d(3) = -cos(2*pi*f_c*2/fs);
for n = 1:length(x)
    if (handles.LFO_1.checkbox || handles.LFO_2.checkbox) && mod(n-1,LFO_res) == 0
        if handles.LFO_1.checkbox
            f_c = handles.LFO_1.x(n);
            d = -cos(2*pi*f_c/fs);
        end
        if handles.LFO_2.checkbox
            mix(n:n+LFO_res-1,1) = handles.LFO_2.x(n);
            mix(n:n+LFO_res-1,2) = handles.LFO_2.x(n);
        end
    end
    % Filtro
    for i = 1:3
        if i > 1
            x(n,:) = y(n,:,i-1);
        end
        xh_new = x(n,:) - d(i).*(1-c(i)).*xh(1,:,i) + c(i).*xh(2,:,i);
        ap_y(:,:,i) = -c(i) .* xh_new + d(i).*(1-c(i)).*xh(1,:,i) + xh(2,:,i);
        xh(:,:,i) = [xh_new; xh(1,:,i)];
        y(n,:,i) = x(n,:) + ap_y(:,:,i);
    end
    %if mod(n,20000) == 0
    %   waitbar(n/length(handles.x(:,1)),wb,'Processing...');        % Dialogo de espera
    %end
end

audioout = audioplayer(y,fs);
Y = fft(y)/length(n);
f = 1:fs/2;
subplot(2,1,1)
loglog(f,abs(X(1:fs/2)))
subplot(2,1,2)
loglog(f,abs(Y(1:fs/2)))