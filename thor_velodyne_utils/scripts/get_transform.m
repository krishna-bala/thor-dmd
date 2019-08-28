function [T,R] = get_transform(matFileName, n)

% First we load the mat file.
matFileStruct = load(matFileName);

% What's the name of the structure element? 
elemName = strtok(matFileName, '.');

% Extract the velodyne translations and rpys
VelodyneTranslations = squeeze(matFileStruct.(elemName).RigidBodies.Positions(12,:,:));
VelodyneRPYs = squeeze(matFileStruct.(elemName).RigidBodies.RPYs(12,:,:));

% Filter out NaN values.
VelodyneTranslations = rmmissing(VelodyneTranslations,2);
VelodyneRPYs = rmmissing(VelodyneRPYs,2);

% Convert Translation data to meters from mm.
VelodyneTranslations = VelodyneTranslations / 1000.00;

% Convert RPY data to radians from degrees.
VelodyneRPYs = VelodyneRPYs * pi / 180.00;

if n == 0
  n = size(VelodyneTranslations,2);
end

T = (1/n) * sum(VelodyneTranslations(:,1:n),2);
R = atan2((1/n) * sum(sin(VelodyneRPYs(:,1:n)),2),(1/n) * sum(cos(VelodyneRPYs(:,1:n)),2));

% There is a ninety degree offset between the velodyne's base and it's
% Qualisys base frame. 
R(3) = R(3) + pi/2;

fprintf("Use this command to start a static transform publisher:\n");
fprintf("\trosrun tf static_transform_publisher %.4f %.4f %.4f %.4f %.4f %.4f map velodyne 20\n", T(1), T(2), T(3), R(3), R(2), R(1))
fprintf("You can add this to the launch file as well.\n");
fprintf("Please look at rosbag_velodyne_viz.launch in this package");

end


