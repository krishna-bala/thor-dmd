for exp_id = 1
    for round_id = 1:length(exp{exp_id})
        for object_id = 3:12
            traj_restored = restoreTrajectory(exp, exp_id, round_id, object_id);
            b = zeros(1,size(traj_restored,1),size(traj_restored,2));
            b(1,:,:) = traj_restored;
            exp{exp_id}{round_id}.RigidBodies.Positions(object_id,1:2,:) = b;
        end
    end
end

for exp_id = 2:3
    for round_id = 1:length(exp{exp_id})
        for object_id = 3:13
            traj_restored = restoreTrajectory(exp, exp_id, round_id, object_id);
            b = zeros(1,size(traj_restored,1),size(traj_restored,2));
            b(1,:,:) = traj_restored;
            exp{exp_id}{round_id}.RigidBodies.Positions(object_id,1:2,:) = b;
        end
    end
end