% Load all recordings

load('Exp_1_run_1')
load('Exp_1_run_2')
load('Exp_1_run_3')
load('Exp_1_run_4')
load('Exp_2_run_1')
load('Exp_2_run_2')
load('Exp_2_run_3')
load('Exp_2_run_4')
load('Exp_2_run_5')
load('Exp_3_run_1')
load('Exp_3_run_2')
load('Exp_3_run_3')
load('Exp_3_run_4')

exp{1} = {Experiment_1_run_1_0050,Experiment_1_run_2_0051,Experiment_1_run_3_0052,Experiment_1_run_4_0053};
exp{2} = {Experiment_2_run_1_0054,Experiment_2_run_2_0055,Experiment_2_run_3_0056,Experiment_2_run_4_0057,Experiment_2_run_5_0058};
exp{3} = {Experiment_3_run_1_0059,Experiment_3_run_2_0060,Experiment_3_run_3_0061,Experiment_3_run_4_0062};

exp{3}{3}.Trajectories.Labeled.Data(1:5,:,:) = [];

% Defining the total amount of tracked markers in each run

markers_count = [45,45,45,45,50,50,50,50,50,50,50,50,50];
counter = 1;
for exp_id = 1:3
    for round_id = 1:length(exp{exp_id})
        if(size(exp{exp_id}{round_id}.Trajectories.Labeled.Data,1) ~= markers_count(counter))
            disp(['For experiment ',int2str(exp_id),' ', int2str(round_id), ' the amount of markers does not match the expected.'])
        end
        counter = counter + 1;
    end
end

% Load maps

map{1} = imread('orebro_map.png');
map{2} = imread('orebro_map.png');
map{3} = imread('orebro_map_exp3.png');

for exp_id=1:3
    map{exp_id} = map{exp_id}(:,:,1);
    map{exp_id} = flip(map{exp_id});
    map{exp_id} = map{exp_id}';
    [obst_x{exp_id},obst_y{exp_id}] = find(map{exp_id} == 0);
    obst_x{exp_id} = obst_x{exp_id} * 10 - 11000;%7000;
    obst_y{exp_id} = obst_y{exp_id} * 10 - 10000;%6500;
    shuffle = randperm(length(obst_x{exp_id}));
    obst_x{exp_id} = obst_x{exp_id}(shuffle);
    obst_y{exp_id} = obst_y{exp_id}(shuffle);
end

% Define unique colors for 13 objects:
% L_frame, Helmet_1, ... , Helmet_10, Velodyne, Robot

body_colors = [
    0,0,0
    0,0,1
    0,1,0
    1.0,0.2,0.2
    1,1,0
    1,0,1
    0,1,1
    1,0.8,0
    0,0.6,1
    0.8,1,0
    0.5,0.5,0.5
    0.8,0.8,0.8
    0.1,0.1,0.1];

restore_data_from_markers

% Experiment 2
time = 0.01; % time between frames (100 Hz)
So = NaN(6,50000,13,5); 
% So = states x frame x agent_id x trial

% observable states:    (5x1)
%
%   pos_x   (cm)
%   pos_y   (cm)
%   vel_x   (cm/s)
%   vel_y   (cm/s)
%   theta   (rad)
%   abs_vel (cm/s)

% agent_id:             (13x1)
%
%   agent1:     L_Frame (tbd)
%   agent2:     Helmet_1
%   agent(n+1): Helmet_n
%   agent11:    Helmet_10
%   agent12:    Velodyne
%   agent13:    Robot

vx_queue = zeros(1,25);
vy_queue = zeros(1,25);

for i = 1:1
    num_frames = exp{1,2}{1,i}.Frames;
    for j = 1:13
        for k = 1:num_frames
            So(1,k,j,i) = exp{1,2}{1,i}.RigidBodies.Positions(j,1,k);
            So(2,k,j,i) = exp{1,2}{1,i}.RigidBodies.Positions(j,2,k);
            if k == 1   % if first frame, set prior position to zero
                px0 = 0;
                py0 = 0;
            else
                px0 = So(1,k-1,j,i); % set prior position to pos at prev frame
                py0 = So(2,k-1,j,i);
            end
            
            dx = (So(1,k,j,i) - px0);                       % calculate change in xpos from prev frame to current frame
            dy = (So(2,k,j,i) - py0);                       % calculate change in ypos from prev frame to current frame
            vx_queue(mod(k,25)+1) = dx/time;                % add instant x velocity to queue
            vy_queue(mod(k,25)+1) = dy/time;                % add instant y velocity to queue
            So(3,k,j,i) = mean(vx_queue);                   % set hyperparemeter 3 to vel_x moving avg (25 frame) (cm/s)
            So(4,k,j,i) = mean(vy_queue);                   % set hyperparameter 4 to vel_y (cm/s)
            So(5,k,j,i) = tan(dy/dx)*180/pi;                % set hyperparameter 5 to theta (deg)
            So(6,k,j,i) = sqrt(mean(vx_queue)^2 + mean(vy_queue)^2);  % set hyperparameter 6 to abs_vel (cm/s)
            if dy < 0
                if dx < 0
                    So(5,k,j,i) =  So(5,k,j,i) + 180;
                else
                    So(5,k,j,i) =  360 - So(5,k,j,i);
                end
            end     
        end
    end
end

x = 1:num_frames;
y = So(6,1:k,11,1);
plot(x,y)           
% Plots 25 frame moving average absolute velocity vs frames

save('So.mat','So')


% Sg = NaN(4,1,13,5); 
% % E = variable * 1 * participant id * experiment number
% for i = 1:1
%     num_frames = exp{1,2}{1,i}.Frames;
%     t_end = num_frames;
%     for j = 1:13
%         while So(1,t_end,j,i) == 0
%             t_end = t_end-1;
%         end
%         Sg(1,1,j,i) = So(1,t_end,j,i);
%         Sg(2,1,j,i) = So(2,t_end,j,i);
%         Sg(3,1,j,i) = 1;
%         Sg(4,1,j,i) = So(5,t_end,j,i);
%     end
% end
