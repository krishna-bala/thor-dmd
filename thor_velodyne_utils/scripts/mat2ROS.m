function mat2ROS(matFileLocation, matFileName)

% First we load the mat file.
matFileStruct = load(matFileLocation + matFileName);

% What's the name of the structure element? 
elemName = strtok(matFileName, '.');

pubs = [];
total_observations = size(squeeze(matFileStruct.(elemName).RigidBodies.Positions(1,:,:)),2);

% Get timestamp:

stampstr = strtok(regexprep(strtrim(matFileStruct.(elemName).Timestamp), '\t', '$'), '$');

% Qualisys doesn't include the milliseconds as part of the time stamp. 
% We obtain this value from the TSV file. 
% Replace this value with correct value from the following (obtained from
% the TSV files exported from Qualisys.
% ex1_run1 = 979 ms
% ex1_run2 = 565 ms
% ex1_run3 = 577 ms
% ex1_run4 = 817 ms
% ex2_run5 = 361 ms
% ex3_run1 = 645 ms
% ex3_run2 = 289 ms
% ex3_run3 = 622 ms
% ex3_run4 = 236 ms
stamp = datetime(stampstr, 'InputFormat','yyyy-MM-dd, HH:mm:ss', 'TimeZone', 'Europe/Zurich') + milliseconds(236)
stamp_secs = posixtime(stamp)

for i = 1:13
  pubs = [pubs, rospublisher("object_" + num2str(i) ,'geometry_msgs/PoseStamped')];
end

obj1 = ProgressBar(total_observations,'Title', 'Publishing ros messages');

for i = 1:total_observations 
  for j = 1:13
    msg = rosmessage('geometry_msgs/PoseStamped');
  
    this_msg_time = stamp_secs + (i-1)/100;
    msg.Header.FrameId = 'map';
    msg.Header.Stamp.Sec = uint32(floor(this_msg_time));
    msg.Header.Stamp.Nsec = uint32((this_msg_time - floor(this_msg_time)) * 1e9);
  
    Translation = matFileStruct.(elemName).RigidBodies.Positions(j,:,i);
    RPY = matFileStruct.(elemName).RigidBodies.RPYs(j,:,i);
 
    % Convert Translation data to meters from mm.
    Translation = Translation / 1000.00;

    % Convert RPY data to radians from degrees.
    RPY = RPY * pi / 180.00;
  
    % requires aerospace toolbox
    Quat = angle2quat(RPY(3), RPY(2), RPY(1), 'zyx');
    if isnan(Translation(1)) || isnan(Translation(2)) || isnan(Translation(3))
      continue;
    end
      
    msg.Pose.Position.X = Translation(1);
    msg.Pose.Position.Y = Translation(2);
    msg.Pose.Position.Z = Translation(3);
    
    msg.Pose.Orientation.W = Quat(1);
    msg.Pose.Orientation.X = Quat(2);
    msg.Pose.Orientation.Y = Quat(3);
    msg.Pose.Orientation.Z = Quat(4);
    
    send(pubs(j), msg);
    pause(0.00001);
  end
  obj1.step([], [], []);
end
end