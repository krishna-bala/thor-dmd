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

% Experiment 1
time = 0.01;
So = NaN(5,50000,13,5); 
% So = 1 * variable * time * participant id * experiment number
for i = 1:5
    matrix_size = size(exp{1,2}{1,i}.RigidBodies.RPYs);
    time_step = matrix_size(3);
    for j = 1:13
        for k = 1:time_step
            So(1,k,j,i) = exp{1,2}{1,i}.RigidBodies.Positions(j,1,k);
            So(2,k,j,i) = exp{1,2}{1,i}.RigidBodies.Positions(j,2,k);
            if k == 1
                px0 = 0;
                py0 = 0;
            else
                px0 = So(1,k-1,j,i);
                py0 = So(2,k-1,j,i);
            end
            dx = (So(1,k,j,i) - px0);
            dy = (So(2,k,j,i) - py0);
            So(3,k,j,i) = dx/time;
            So(4,k,j,i) = dy/time;
            So(5,k,j,i) = tan(dy/dx)*180/pi;
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


Sg = NaN(4,1,13,5); 
% E = 1 * variable * 1 * participant id * experiment number
for i = 1:5
    matrix_size = size(exp{1,2}{1,i}.RigidBodies.RPYs);
    time_step = matrix_size(3);
    t_end = time_step;
    for j = 1:13
        while So(1,t_end,j,i) == 0
            t_end = t_end-1;
        end
        Sg(1,1,j,i) = So(1,t_end,j,i);
        Sg(2,1,j,i) = So(2,t_end,j,i);
        Sg(3,1,j,i) = 1;
        Sg(4,1,j,i) = So(5,t_end,j,i);
    end
end
