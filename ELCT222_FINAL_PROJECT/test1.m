clear all
close all

[y,Fs] = audioread('disfigure01.wav');
 
player = audioplayer(y,Fs);
player.TimerPeriod=0.025;

player.play;

while(player.isplaying)
   currentfft(player,y,Fs)
   drawnow;
end

function currentfft(player,Y,FS)
    sampleNumber=get(player,'CurrentSample');
    timerVal=get(player,'TimerPeriod');
    
    %Get channel one values for our window around the current sample number
    s1=Y(floor(sampleNumber-((timerVal*FS)/2)):floor(sampleNumber+((timerVal*FS)/2)),1);
    
    n = length(s1)
    p = fft(s1); % take the fourier transform
    
    nUniquePts = ceil((n+1)/2);
    p = p(1:nUniquePts); % select just the first half since the second half
    			 % is a mirror image of the first
    p = abs(p); % take the absolute value, or the magnitude
    p = p/n; % scale by the number of points so that
             % the magnitude does not depend on the length
             % of the signal or on its sampling frequency
    
    p = p.^2;  % square it to get the power
    p=transpose(p);  %converts to a horizontal vector
    
    % multiply by two
    if rem(n, 2) % odd nfft excludes Nyquist point
        p(2:end) = p(2:end)*2;
    else
        p(2:end -1) = p(2:end -1)*2;
    end
    
    freqArray1 = (0:nUniquePts-1) * (FS / n) / 1000; % create the frequency array in kHz
    freqArray2 = -(0:nUniquePts-1) * (FS / n) / 1000; % create the frequency array

    % M randomly generates a double value 0-1 for R,G,B
    M = 1.*rand(1, 3, 'double');
    vis = polarplot(freqArray1, p, freqArray2, p, 'LineWidth', 2);
    set(vis, 'Color', M);
    pax1 = gca;
    set(pax1,'color',[0 0 0]); % polar plot background color
    pax1.ThetaLim = [0 360];
    pax1.ThetaTickLabel = '';
    pax1.RTickLabel = '';
    pax1.RGrid = 'off';
    pax1.ThetaGrid = 'off';
    pax1.RLim = [0 0.03];
    %pax1.ThetaZeroLocation = 'top';


%                  RLim: [0 14]
%        ThetaAxisUnits: 'degrees'
%              ThetaDir: 'counterclockwise'
%     ThetaZeroLocation: 'right'

%     xlabel('Frequency (kHz)')
%     ylabel('Power (watts)')
%     title('Frequency vs. Power')
%     axis([0 2 0 0.0099]);
end
