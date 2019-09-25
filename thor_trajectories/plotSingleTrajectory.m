function plotSingleTrajectory(exp, exp_id, round_id, body_id, varargin)

if(nargin==5)
    color = varargin{1};
else
    color = [rand,rand,rand];
end

traj = squeeze(exp{exp_id}{round_id}.RigidBodies.Positions(body_id,1:2,:));
plot(traj(1,:),traj(2,:),'Color',color)
axis equal

end