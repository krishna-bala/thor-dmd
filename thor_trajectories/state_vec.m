% State Vector Manipulation
% Input: 3D Array of agents' states (x,y) per frame per trial of experiment 2
% Output: Supplemented 3D array with calculated velocity (Vx, Vy)
clear all; close all; clc

load('obst_x.mat')
load('obst_y.mat')
load('body_id_pos.mat')
% body_id_pos.mat:
% (2n)x(max_frames)x(trial) size matrix
% n = # agents/obstacles, 
% n = 1: Helmet_1, 
% ... 
% n = 10: Helmet_10 
% n = 11: Velodyne (stationary)
% n = 12: Robot
num_trial = length(body_id_pos(1,1,:))

trial_1 = body_id_pos(:,:,1);
trial_2 = body_id_pos(:,:,2);
trial_3 = body_id_pos(:,:,3);
trial_4 = body_id_pos(:,:,4);
trial_5 = body_id_pos(:,:,5);

% Need to:
%   - add velocities of each agent
%   - add orientation of each agent
%   - add goal position of ego agent
%   - add distance to other agents
%   - 
%   - segment each trial from each ego agent's POV into initial conditions and goal position
% 
% After each experiment is segmented into "runs" of env configurations from the agent's POV
% Need to map (x,y) coord to distance to closest obstacle
% Need to assemble into X matrix consisting of:
% 
% X =
% ego agent1:   x_pos, y_pos, vel_x, vel_y, goal_x, goal_y
% agent2:       x_pos, y_pos,vel_x, vel_y, d_ego_agent
% ...
% agent11:      x_pos, y_pos,vel_x, vel_y, d_ego_agent

%% Trial 1

helmet_1 = body_id_pos(1:3,1,:1







