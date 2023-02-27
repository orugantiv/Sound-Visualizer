# Project Title: iTunes Visualizer using Matlab
This project involves the implementation of an iTunes visualizer using Matlab, where a user can import their own song and visualize it using some kind of Fourier transform. The audioread tool is used to import the song into Matlab, which supports MP3 files as well.

## Song Selection
For this project, the song "Blank" by Disfigure was chosen due to its noticeable bass drop at 30 seconds into the song.

## Visualization
A scatter plot and polar plot were used to give a visual representation of the music, with the bass being highlighted by modifying the data used for the polar plot. Customization was applied to both plots to enhance their visual appeal.

## User Interface
A user interface was created that allowed the user to stop the music or exit the program. This was achieved by creating UI objects such as windows and buttons. The buttons are used to stop the music or exit out of the window. Two timer objects were created to indicate playable time and playing time. The UI objects were set at a static position, and the color for the buttons were set to black while having white text to match the polar and scatter plots.

## Logic
The code block includes the required logic with UI inputs while the music is played. Stop and exit buttons are implemented, and the input is checked during every iteration of the loop. The timer is updated and changed during every iteration of the loop, and a function is called to plot power and transformation on polar and scatter plots for each sample.

## Output
The output of the program is a functional visualizer that is capable of displaying the power usage for each sample of the song. However, there are noticeable performance drops due to intense CPU/GPU usage.

The power usage for each sample of the song is as follows:

Max: 8.93e-2 W
Min: 3.8e-07 W
Mean: 1.7e-3 W using MATLAB.
The resulting visualization shows a noticeable change in the polar plot around 30 seconds, where the heavy bass is highlighted.

Note: The code and image examples shown in this description are not included in this README.md file. See the included ppt.