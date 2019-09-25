function result = restoreTrajectory(exp, exp_id, round_id, object_id)

% The amount of markers in each helmet, the velodyne and the robot

object_marker_counter = [NaN,NaN,4,4,5,5,5,5,5,4,4,4,5];

markers_traj_x = [];
markers_traj_y = [];
markers_sum = sum(object_marker_counter(3:object_id-1));
for marker_id = 1:object_marker_counter(object_id)
    markers_traj_x = [markers_traj_x;squeeze(exp{exp_id}{round_id}.Trajectories.Labeled.Data(markers_sum + marker_id,1,:))'];
    markers_traj_y = [markers_traj_y;squeeze(exp{exp_id}{round_id}.Trajectories.Labeled.Data(markers_sum + marker_id,2,:))'];
end
helmet_1_x_restored_alt =  nan_aware_average(markers_traj_x);
helmet_1_y_restored_alt =  nan_aware_average(markers_traj_y);

result = [helmet_1_x_restored_alt; helmet_1_y_restored_alt];

original_traj = squeeze(exp{exp_id}{round_id}.RigidBodies.Positions(object_id,1:2,:));

result(find(~isnan(original_traj))) = original_traj(find(~isnan(original_traj)));

end