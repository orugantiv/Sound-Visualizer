clear all
close all

song_name = 'disfigure01.wav';

fig = uifigure('Name', 'Visualizer Panel');
fig.Position = [100, 200, 1000, 500];
p = uipanel(fig,'Position',[0 0 550 500]);
ax = uiaxes(p,'Position',[10 10 400 475]);
pax=polaraxes figure.panel
stop = uibutton(fig,'state', 'Text', 'Stop', 'FontSize',14);
stop.Position = [425 350 100 100];
Exit = uibutton(fig,'state', 'Text', 'Exit', 'FontSize',14);
Exit.Position = [425 200 100 100];
%right up button_width button_height

[y,Fs] = audioread(song_name);

player = audioplayer(y,Fs);
player.TimerPeriod=0.025;

N = length(y);
slength = N/Fs; %song length 

timetext = sprintf('%02d:%02d:%02d', floor(slength/3600),...
floor(slength/60), floor(mod(slength,60)));

timebox = uilabel(fig,'Text',timetext,'FontSize',16);
currenttimebox = uilabel(fig,'Text','00:00:00','FontSize',16);
timebox.Position = [445 95 100 20];
currenttimebox.Position = [445 75 100 20];

drawnow;
pause(1);
t1 = timetic;

i = 0; flag = 0; remaining = slength;
while true
   if i == 0
       player.play
       tic(t1);
end
   if toc(t1) >= slength
       while true
           player.pause;
           if Exit.Value == 1
               flag = 1;
               delete(fig);
               break
           end
           pause(0.05);
       end
       if flag == 1
           delete(fig);
           break
       end
   end
   while(stop.Value ~=0)
       pause(t1);
       player.pause;
       pause(0.01);
       if Exit.Value == 1
            flag = 1;
            break
       end
       if flag == 1
           delete(fig);
           break
       end
   end
   start(t1);
   player.resume;
   stop.Value = 0; 
   sampleNumber = currentfft(player, y, Fs, ax);

   drawnow;
   if Exit.Value == 1
       player.pause;
       delete(fig);
       break
   end
   currenttimetext = sprintf('%02d:%02d:%02d', floor(toc(t1)/3600),...
   floor(toc(t1)/60), floor(mod(toc(t1),60)));
   currenttimebox.Text = currenttimetext;
   i = i + 1;
end
function sampleNumber = currentfft(player, Y, FS, ax)
    sampleNumber=get(player,'CurrentSample');
    timerVal=get(player,'TimerPeriod');
    %Get channel one values for our window around the current sample number
    s1=Y(floor(sampleNumber-((timerVal*FS)/2)):floor(sampleNumber+...
    ((timerVal*FS)/2)),1);
    n = length(s1);
    p = fft(s1); % take the fourier transform
    nUniquePts = ceil((n+1)/2);
    p = p(1:nUniquePts); % select just the first half since the second half
    			 % is a mirror image of the first
    p = abs(p); % take the absolute value, or the magnitude
    p = p/n; % scale by the number of points so that    
    p = p.^2;  % square it to get the power
    p=transpose(p);  %converts to a horizontal vector
    
    % multiply by two
    if rem(n, 2) % odd nfft excludes Nyquist point
        p(2:end) = p(2:end)*2;
    else
        p(2:end -1) = p(2:end -1)*2;
    end
    
    freqArray = (0:nUniquePts-1) * (FS / n); % create the frequency array
    

    bar(ax, freqArray/1000, p, 'b');
    title(ax,'Frequency vs. Power','FontSize',16);
    xlabel(ax,'Frequency (kHz)','FontSize',12);
    ylabel(ax,'Power (watts)','FontSize',12);
    ax.XLim = [0 2];
    ax.YLim = [0 0.0099];


    freqArray1 = (0:nUniquePts-1) * (FS / n) / 1000; % create the frequency array in kHz
    freqArray2 = -(0:nUniquePts-1) * (FS / n) / 1000; % create the frequency array

    M = 1.*rand(1, 3, 'double');
    vis = polarplot(freqArray1, p, freqArray2, p, 'LineWidth', 5);
    set(vis, 'Color', M);
    pax1 = gca;
    set(pax1,'color',[0 0 0]); % polar plot background color
    pax1.ThetaLim = [-180 180];
    pax1.ThetaTickLabel = '';
    pax1.RTickLabel = '';
    pax1.RGrid = 'off';
    pax1.ThetaGrid = 'off';
    pax1.RLim = [0 0.03];
    pax1.ThetaZeroLocation = 'top';
end



