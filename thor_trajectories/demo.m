clear
close all

load_data

% Plot each of the three experiments in a separate figure
for exp_id=2:2
    figure
    hold on
    axis equal
    plotMap(obst_x,obst_y,exp_id)
    for round_id=1:length(exp{exp_id})
        for body_id=2:13
            plotSingleTrajectory(exp,exp_id,round_id,body_id,body_colors(body_id,:))
        end
    end
end

% Modify the data structure with adding lost positions in the tracks
restore_data_from_markers

% Create a video for every experiment sequence
prompt = 'Play the scenarios? (y/n)\n';
str = input(prompt,'s');
if str=='y'
    playdata
end