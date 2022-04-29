clear all
close all

song_name = 'disfigure01.wav';

%Variables to control window height/width
w = 1000;
h = 500;
x_pos = 100; 
y_pos = 200;

%Create ui panel
fig = uifigure('Name', 'Visualizer Panel', 'Color',[0.94 0.94 0.94]);
set(fig,'color',[0, 0, 0]);
fig.Position = [x_pos, y_pos, w-32, h];
p = uipanel(fig,'Position',[x_pos-x_pos y_pos-y_pos (w/2) h]);
ax = uiaxes(p,'Position',[0 10 (w/20)*9 h*0.94]);
p = uipanel(fig,'Position',[(w/2) 0 w/2 h]);

%Define polar graph
pax=polaraxes(p);

%Stop button creation
w_b = 100; h_b = 100;
stop = uibutton(fig,'state','Text','Stop','FontSize',17);
stop.Position = [(w-w_b)/2 340 w_b h_b];
stop.BackgroundColor = [0 0 0];
stop.FontColor = [1 1 1];
%Exit button creation
Exit = uibutton(fig,'state','Text','Exit','FontSize',17);
Exit.Position = [(w-w_b)/2 200 w_b h_b];
Exit.BackgroundColor = [0 0 0];
Exit.FontColor = [1 1 1];

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
timebox.Position = [19+(w-w_b)/2 95 100 20];
currenttimebox.Position = [19+(w-w_b)/2 75 100 20];

drawnow;
pause(1);
t1 = timetic;

i = 0; flag = 0; remaining = slength;
% Playes music as soon as the program starts 
player.play
% Sets the timer tick to 0 
tic(t1);
% This while loop handles all operations regarding playing music and calling functions
% to plot computed values at different time intervels.  
while true
    % this if statement is true once the song is fully played 
   if toc(t1) >= slength
       % Setting an infinite while loop until the user exits out of the
       % window
           player.pause;
           % Deletes the window
           if Exit.Value == 1
               flag = 1;
               delete(fig);
               break
           end
           % Stops the timer 
           pause(0.05);
   else 
       % This stops the music when stop button is pressed
   while(stop.Value ~=0)
       % Pausing the timer 
       pause(t1);
       % Pausing the music 
       player.pause;
       pause(0.01);
       % The exit is invoked 
       if Exit.Value == 1
            % Setting the exit flag 
            flag = 1;
            break
       end
       % If exit flag is true, deletes the window
       if flag == 1
           delete(fig);
           break
       end
   end
   % Starts timer 
   start(t1);
   % con. ply music 
   player.resume;
   % stop val is zero while playing 
   stop.Value = 0; 
   % Plotting the current sample into ploar and scatter 
   sampleNumber = currentfft(player, y, Fs, ax, pax);

   % Drawing the new plot
   drawnow;
   % The exit button while playing 
   if Exit.Value == 1
       % Pausing the music before exiting 
       player.pause;
       % deleting the window
       delete(fig);
       break
   end
   % Updating the current timer 
   currenttimetext = sprintf('%02d:%02d:%02d', floor(toc(t1)/3600),...
   floor(toc(t1)/60), floor(mod(toc(t1),60)));
   currenttimebox.Text = currenttimetext;
   i = i + 1;
   end
end
function sampleNumber = currentfft(player, Y, FS, ax, pax)
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
    p=transpose(p); %converts to a horizontal vector


            % -----HIGHLIGHT BASS-----
    if Y>20
    p1=p*.001;  %converts to a horizontal vector
    else
    p1=p*2;     %converts to a horizontal vector
    end
            % -----HIGHLIGHT BASS-----
        
            
    % multiply by two
    if rem(n, 2) % odd nfft excludes Nyquist point
        p(2:end) = p(2:end)*2;
    else
        p(2:end -1) = p(2:end -1)*2;
    end
    
    %Generate Random Colors
    M = 1.*rand(1, 3, 'double');
    
    %Graph Scatter Plot
    freqArray = (0:nUniquePts-1) * (FS / n); % create the frequency array
    s = scatter(ax, freqArray/1000, p, 'b');
    s.Marker = 'p';
    s.MarkerEdgeColor = M;
    s.MarkerFaceColor = M;
    
    title(ax,'Frequency vs. Power','FontSize',16,'color',[0 0 0]);
    xlabel(ax,'Frequency (kHz)','FontSize',12,'color',[0 0 0]);
    ylabel(ax,'Power (watts)','FontSize',12,'color',[0 0 0]);
   
    ax.XLim = [0 2];
    ax.YLim = [0 0.0099];
    set(ax,'color',[0 0 0]);

    %Graph Polar Plot
    freqArray1 = (0:nUniquePts-1) * (FS / n) / 1000; % create the frequency array in kHz
    freqArray2 = -(0:nUniquePts-1) * (FS / n) / 1000; % create the frequency arry in kHz
   
    freqArray1_mod1 = freqArray1+180;   %Modified Frequency Array
    freqArray2_mod1 = freqArray2+180;   %Modified Frequency Array
    freqArray1_mod2 = freqArray1-180;   %Modified Frequency Array
    freqArray2_mod2 = freqArray2-180;   %Modified Frequency Array

    vis = polarplot(pax, freqArray1, p1, freqArray2, p1, freqArray1_mod1, p1, freqArray2_mod1, p1, freqArray1_mod2, p1, freqArray2_mod2, p1, 'LineWidth', 5);
    set(vis, 'Color', M);
    
    set(pax,'Color',[0 0 0]);
    pax.ThetaLim = [-180 180];
    pax.ThetaTickLabel = '';
    pax.RTickLabel = '';
    pax.RGrid = 'off';
    pax.ThetaGrid = 'off';
    pax.RLimMode = 'manual';
    pax.RLim = [0 0.03];
end