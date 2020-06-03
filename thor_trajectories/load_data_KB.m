clear all; close all; clc;

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
    obst_y{exp_id} = obcst_y{exp_id} * 10 - 10000;%6500;
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

%% Experiment 2 - eDMD & SINDy setup

time = 0.01; % time between frames (100 Hz)
So = NaN(7,50000,13,5);         % So = states x frame x agent_id x trial
    

                                % states:    (7x1)
                                %
                                %   pos_x       (cm)
                                %   pos_y       (cm)
                                %   vel_x       (cm/s)
                                %   vel_y       (cm/s)
                                %   theta       (rad)
                                %   abs_vel     (cm/s)
                                %   goal_pos    (cm)

                                % agent_id:             (13x1)
                                %
                                %   agent1:     L_Frame (tbd)
                                %   agent2:     Helmet_1
                                %   agent(n+1): Helmet_n
                                %   agent11:    Helmet_10
                                %   agent12:    Velodyne
                                %   agent13:    Robot

vel_mov_avg = 25;               % number of frames to calculate moving average

vx_queue = zeros(1,vel_mov_avg); % moving average x vel queue
vy_queue = zeros(1,vel_mov_avg); % moving average y vel queue

Pg = zeros(1,3);        % initialize Pg: (number of goal positions) x (x_pos,y_pos,frame)


segment = zeros(1,2,5);     % initialize segment to capture start/stop frames when
                            % ego agent is on map (not NaN position) for
                            % each trial


for i = 1:1                             % i = trial
    
    num_frames = exp{1,2}{1,i}.Frames;  % frames in trial
    
    for j = 1:13                        % j = agent_id
        
        goal_counter = 0;               % counter for recording goal positions of ego agent
        seg_counter = 0;                % counter for recording frames where ego agent pos is not NaN
        
        for k = 1:num_frames            % k = frame
            
            x = exp{1,2}{1,i}.RigidBodies.Positions(j,1,k);         % current frame x pos
            y = exp{1,2}{1,i}.RigidBodies.Positions(j,2,k);         % current frame y pos
            So(1,k,j,i) = x;            % set hyperparemeter 1 to x pos   (cm)
            So(2,k,j,i) = y;            % set hyperparameter 2 to y pos   (cm)
            
            if k == 1                   % if first frame, set prior position to zero
                px0 = 0;
                py0 = 0;
            else
                px0 = So(1,k-1,j,i);    % set prior position to pos at prev frame
                py0 = So(2,k-1,j,i);
            end
            
            dx = (So(1,k,j,i) - px0);                       % calculate change in x pos from prev frame to current frame
            dy = (So(2,k,j,i) - py0);                       % calculate change in y pos from prev frame to current frame
            
            vx_queue(mod(k,vel_mov_avg)+1) = dx/time;       % add instant x velocity to queue
            vy_queue(mod(k,vel_mov_avg)+1) = dy/time;       % add instant y velocity to queue
            
            % Note: This calculates trailing 25 frame average. May need to
            % calculate the central 25 frame average.
            
            avg_vx  = mean(vx_queue);               % x velocity (cm/s) (moving avg)
            avg_vy  = mean(vy_queue);               % y velocity (cm/s) (moving avg)
            abs_vel = sqrt(avg_vx^2 + avg_vy^2);    % abs velocity (cm/s) (moving avg)
            
            theta   = tan(dy/dx)*180/pi;            % orientation (in degrees)
            
            So(3,k,j,i) = avg_vx;   % set hyperparemeter 3 to vel_x   (cm/s)
            So(4,k,j,i) = avg_vy;   % set hyperparameter 4 to vel_y   (cm/s)
            So(5,k,j,i) = theta;    % set hyperparameter 5 to theta   (deg)
            So(6,k,j,i) = abs_vel;  % set hyperparameter 6 to abs_vel (cm/s)
            
            if(j == 11)                     % if agent of interest (helmet10, inspector)
                
                if(~isnan(x) & ~isnan(y) )  % if current x,y pos not NaN
                    
                    if(abs_vel < 250)       % if arriving at goal position
                        
                        if Pg(1,3) == 0     % if no goal position set
                            
                            goal_counter = goal_counter + 1;
                            Pg(goal_counter,:) = [So(1,k,j,i) So(2,k,j,i) k];
                            
                        else                % not the first goal position
                            
                            prev_Pgx = Pg(goal_counter,1);
                            prev_Pgy = Pg(goal_counter,2);
                            
                            if( sqrt((x - prev_Pgx)^2 + (y - prev_Pgy)^2) > 1000)   % If our new goal is more than 1m
                                                                                    % away from the previous goal.
                                                                                    
                                goal_counter = goal_counter + 1;                    % Step goal_counter.
                                Pg(goal_counter,:) = [So(1,k,j,i) So(2,k,j,i) k];   % Add curr frame coordinates 
                                                                                    % to goal position matrix.
                            end
                        end
                    end
                else
                    if Pg(1,3) ~= 0 % if a goal position exists
                        
                        prev_x = So(1,k-1,j,i);
                        prev_y = So(2,k-1,j,i);
                        
                        if ~isnan(prev_x) & ~isnan(prev_y) % if ego agent's prev_x and prev_y are in the map
                            
                            goal_counter = goal_counter + 1;            % step goal_counter
                            Pg(goal_counter,:) = [prev_x prev_y k-1];   % add previous frame coordinates to goal position matrix
                            
                        end
                    end
                end
                
                if k == 4630
                    test = 0;
                end
                
                if k ~= 1 % not first frame
                    
                    prev_x = So(1,k-1,j,i);
                    prev_y = So(2,k-1,j,i);
                    
                    if ~isnan(x) & ~isnan(y)     % if ego agent's coords are on map

                        if isnan(prev_x) & isnan(prev_y)   % if previous coords were not on map
                            
                            seg_counter = seg_counter + 1;  % new segment
                            segment(seg_counter,1,i) = k;   % "start" frame for current segment
                        end
                        
                    else % ego agent's coords are not on map
                        
                        if ~isnan(prev_x) & ~isnan(prev_y)          % if previous coords were on map
                            segment(seg_counter,2,i) = k;   % "stop" frame for current segment
                        end
                    end
                    
                else % first frame
                    
                    if ~isnan( x ) & isnan( y )     % if ego agent's coords are on map
                        
                        seg_counter = seg_counter + 1;  % new segment
                        segment(seg_counter,1,i) = k;   % "start" frame for current segment
                    end
                end
                
            end
                
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

seg1_trial1 = So(:,segment(1,1,1):segment(1,2,1),:,1);

X = seg1_trial1(:,:,11,:);


for i = 1:length(Pg)
    if i = 1
        X(7,segment(1,1,1):Pg(i+1,3), 11, 1);
    elseif i ~= length(Pg)
        if Pg(i,3) < segment(1,1,1)
        

        

x = 1:(segment(1,2,1)-segment(1,1,1) + 1);
y = seg1_trial1(6,:,11,1);
figure(1)
plot(x,y)
legend('Helmet10 Abs Vel, Seg 1')
xlabel('Frame')
ylabel('cm/s')
title('Abs Vel vs Frame')
% 
% figure(2)
% y1 = So(1,1:k,11,1);
% y2 = So(2,1:k,11,1);
% x = 1:length(y1);
% plot(x,y1)
% hold on
% plot(x,y2)
% 
% figure(3)
% y3 = sqrt(So(1,1:k,11,1).^2 + So(2,1:k,11,1).^2);
% plot(x,y3)


% Plots 25 frame moving average absolute velocity vs frames

save('So.mat','So')

Uo = So(:,:,1:10,:);






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