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

%% Experiment 2 - eDMD & SINDy setup

time = 0.01; % time between frames (100 Hz)
So = cell(8,13,5);  % initialize So cell: states (8) x agent_id (13) x trial (5)
                    % 8x13x5 array of {1 x k} cells, where k is num_frames.
                    
                                % states:    (8)
                                %
                                %   pos_x           (cm)
                                %   pos_y           (cm)
                                %   vel_x           (cm/s)
                                %   vel_y           (cm/s)
                                %   theta           (rad)
                                %   abs_vel         (cm/s)
                                %   goal_pos_x      (cm)
                                %   goal_pos_y      (cm)

                                % agent_id:             (13)
                                %
                                %   agent1:     L_Frame (tbd)
                                %   agent2:     Helmet_1
                                %   agent(n+1): Helmet_n
                                %   agent11:    Helmet_10
                                %   agent12:    Velodyne
                                %   agent13:    Robot
                                
                                % trialss:    (5)
                                % 
                                %   trial1
                                %   ...
                                %   trial5

vel_mov_avg = 25;               % number of frames to calculate moving average

vx_queue = NaN(1,vel_mov_avg); % moving average x vel queue
vy_queue = NaN(1,vel_mov_avg); % moving average y vel queue

Pg = cell(13,5);        % initialize Pg cell: (agents) x (trial)
                        % 
                        % each cell: n x s double array
                        %       
                        % n = num_goal_positions
                        % s = 3 (x, y, frame)
                               


segment = cell(13,5);      % initialize segment cell: (agents) x (trial)
                            % 
                            % each cell: m x p double array
                            %
                            % m = num_segments
                            % p = 2 (start_frame,stop_frame)

trials = 1;

for i = 1:trials                             % i = trial
    
    num_frames = exp{1,2}{1,i}.Frames;  % frames in trial
    
    for j = 1:13                        % j = agent_id
        
        goal_counter = 0;               % counter for recording goal positions of ego agent
        seg_counter = 0;                % counter for recording frames where ego agent pos is not NaN
        
        for k = 1:num_frames            % k = frame
            
            x = exp{1,2}{1,i}.RigidBodies.Positions(j,1,k);         % current frame x pos
            y = exp{1,2}{1,i}.RigidBodies.Positions(j,2,k);         % current frame y pos

            if k == 1                   % if first frame, set prior position to zero
                prev_x = NaN;
                prev_y = NaN;
            else
                prev_x = So{1,j,i}(k-1);    % set prior position to pos at prev frame
                prev_y = So{2,j,i}(k-1);
            end
           
            dx = (x - prev_x);                    % calculate change in x pos from prev frame to current frame
            dy = (y - prev_y);                    % calculate change in y pos from prev frame to current frame
            
            vx_queue(mod(k,vel_mov_avg)+1) = dx/time;       % add instant x velocity to queue
            vy_queue(mod(k,vel_mov_avg)+1) = dy/time;       % add instant y velocity to queue
            
            % Note: This calculates trailing 25 frame average. May need to
            % calculate the central 25 frame average.
            
            avg_vx  = mean(vx_queue(~isnan(vx_queue)));               % x velocity (cm/s) (moving avg)
            avg_vy  = mean(vy_queue(~isnan(vy_queue)));               % y velocity (cm/s) (moving avg)
            abs_vel = sqrt(avg_vx^2 + avg_vy^2);    % abs velocity (cm/s) (moving avg)
            theta   = tan(dy/dx)*180/pi;            % orientation (in degrees)
                        
            % Goal Position Conditional
            if(~isnan(x) && ~isnan(y) )  % if current x,y pos not NaN

                if(abs_vel < 250)       % if arriving at goal position

                    if length(Pg{j,i}) == 0     % if no goal position set

                        goal_counter = goal_counter + 1;
                        Pg{j,i}(goal_counter,:) = [x y k];

                    else                % not the first goal position

                        prev_Pgx = Pg{j,i}(goal_counter,1);
                        prev_Pgy = Pg{j,i}(goal_counter,2);

                        if( sqrt((x - prev_Pgx)^2 + (y - prev_Pgy)^2) > 1000)   % If our new goal is more than 1m
                                                                                % away from the previous goal.                                                                                   
                            goal_counter = goal_counter + 1; 
                            Pg{j,i}(goal_counter,:) = [x y k];   % Add curr frame coordinates 
                                                                 % to goal position matrix.
                        end
                    end
                end
            else % x or y is NaN

                if length(Pg{j,i}) ~= 0 % if a goal position exists

                    if ~isnan(prev_x) && ~isnan(prev_y) % if ego agent's prev_x and prev_y are in the map

                        goal_counter = goal_counter + 1;        
                        Pg{j,i}(goal_counter,:) = [prev_x prev_y k-1];   % add previous frame coordinates to goal position matrix

                    end
                end
            end

            % Segment Conditional
            if k == 1 % first frame

                if ~isnan(x) && isnan(y)     % if ego agent's coords are on map

                    seg_counter = seg_counter + 1;  % new segment
                    segment{j,i}(seg_counter,1) = k;   % "start" frame for current segment
                end

            else

                if ~isnan(x) && ~isnan(y)    % ego agent's coords are on map

                    if isnan(prev_x) && isnan(prev_y)   % if previous coords were not on map

                        seg_counter = seg_counter + 1;     % new segment
                        segment{j,i}(seg_counter,1) = k;   % "start" frame for current segment
                    end

                else    % ego agent's coords are not on map

                    if ~isnan(prev_x) && ~isnan(prev_y)   % previous coords were on map
                        segment{j,i}(seg_counter,2) = k-1;   % "stop" frame for current segment
                    end
                end
                
            end
            
            % Assign hyper-parameters
            So{1,j,i} = [So{1,j,i}, x];            % set hyperparemeter 1 to x pos     (cm)
            So{2,j,i} = [So{2,j,i}, y];            % set hyperparameter 2 to y pos     (cm)
            So{3,j,i} = [So{3,j,i}, avg_vx];       % set hyperparemeter 3 to vel_x     (cm/s)
            So{4,j,i} = [So{4,j,i}, avg_vy];       % set hyperparameter 4 to vel_y     (cm/s)
            So{5,j,i} = [So{5,j,i}, theta];        % set hyperparameter 5 to theta     (deg)
            So{6,j,i} = [So{6,j,i}, abs_vel];      % set hyperparameter 6 to abs_vel   (cm/s)

    
            if dy < 0
                if dx < 0
                    So{5,j,i}(end) =  So{5,j,i}(end) + 180;
                else
                    So{5,j,i}(end) =  360 - So{5,j,i}(end);
                end
            end     
        end
        
        % If agent ends in map in last frame, end the segment
        if seg_counter > 0
            if segment{j,i}(seg_counter,2) == 0
                segment{j,i}(seg_counter,2) = k;
            end
        end

        % Add ZOH step for goal position
        for p = 1:size(Pg{j,i},1)
            
            if p == 1 % first goal position
                So{7,j,i}(1:Pg{j,i}(p,3)) = Pg{j,i}(p,1);
                So{8,j,i}(1:Pg{j,i}(p,3)) = Pg{j,i}(p,2);
            else % not the first goal position
                So{7,j,i}(Pg{j,i}(p-1,3):Pg{j,i}(p,3)) = Pg{j,i}(p,1);
                So{8,j,i}(Pg{j,i}(p-1,3):Pg{j,i}(p,3)) = Pg{j,i}(p,2);
            end
        end
        if size(So{7,j,i},1) ~= 0
            So{7,j,i}(end:k) = NaN;
            So{8,j,i}(end:k) = NaN; 
        end
        
    end
end

X = cell(1,trials); % 1 is a placeholder for the number of segments
U = cell(1,13,trials);

for i = 1:trials

    for j = 1:13
        
        for k = 1:size(segment{11,i},1)
            start = segment{11,i}(k,1);
            stop  = segment{11,i}(k,2);
            
            if j == 11
                X{k,i}(:,1)     = So{1,j,i}(start:stop)';
                X{k,i}(:,2)     = So{2,j,i}(start:stop)';
                X{k,i}(:,3)     = So{3,j,i}(start:stop)';
                X{k,i}(:,4)     = So{4,j,i}(start:stop)';
                X{k,i}(:,5)     = So{5,j,i}(start:stop)';
                X{k,i}(:,6)     = So{6,j,i}(start:stop)';
                U{k,j,i}(:,7)   = So{7,j,i}(start:stop)';
                U{k,j,i}(:,8)   = So{8,j,i}(start:stop)';
            else
                U{k,j,i}(:,1) = So{1,j,i}(start:stop)';
                U{k,j,i}(:,2) = So{2,j,i}(start:stop)';
                U{k,j,i}(:,3) = So{3,j,i}(start:stop)';
                U{k,j,i}(:,4) = So{4,j,i}(start:stop)';
                U{k,j,i}(:,5) = So{5,j,i}(start:stop)';
                U{k,j,i}(:,6) = So{6,j,i}(start:stop)';
            end
        end       
    end   
end

k = 1:length(So{6,11,1});
vel = So{6,11,1};
x = So{1,11,1};
y = So{2,11,1};
vx = So{3,11,1};
vy = So{4,11,1};
theta = So{5,11,1};
gpx = So{7,11,1};
gpy = So{8,11,1};

figure(1)
plot(k,x)
hold on
plot(k,y)
% plot(k,vx)
% plot(k,vy)
% plot(k,theta)
plot(k,vel)
% plot(k,gpx)
% plot(k,gpy)
% legend('x','y','vx','vy','theta','vel','gpx','gpy')
legend('x,','y','vel')
xlabel('Frame')
ylabel('cm/s, cm, or rad')
title('Helmet 10 vs Frame')

% Plots 25 frame moving average absolute velocity vs frames

save('So.mat','So')

