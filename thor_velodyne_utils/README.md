## A package providing utilities for the THÖR dataset.

### DESCRIPTION OF FILES

#### get_transform.m
Calculates and returns Translation and RPY vectors for the Velodyne frame w.r.t the Qualisys frame.

Example usage (MATLAB):

```[T, R] = get_transform('Ex_1_run_1.mat')```

where 'Ex_1_run_1.mat' is the .mat file containing the Qualisys tracks from Experiment 1, run 1.
Returned values: `T` is the translation vector and `R` is the RPY vector of the Velodyne frame.


#### mat2ROS.m
Publishes all tracked Qualisys trajectories as ROS messages (geometry_msgs/PoseStamped).
Doesn't replay messages from .mat file. It plays it out. Record them and use other scripts and launch files to properly play them.

You probably don't need this file unless you wish to change the message type of the tracked objects.

Example usage (MATLAB):

```mat2ROS('Ex_1_run_1.mat')```

#### fix_bag_msg_def
Once you have run `mat2ROS` from within matlab (after running roscore and rosbag record -a), use this script to clean out the generated bag file.
You probably don't need this unless you have change the message time in the mat2ROS script and have recorded that was played out from that script.

Example usage (terminal):

```python fix_bag_msg_def.py -v -l ~/Ex1_run1_qualisys_2019-08-28-15-55-48.bag Ex1_run1_qualisys.bag```

#### fix_time_stamps.py
Once the message definitions are cleaned out, use this to fix timestamps in the bag file.
You probably don't need this unless you have had to generate the rosbags again.

Example usage (terminal):

```python fix_time_stamps.py Ex1_run1_qualisys.bag```

#### rosbag_velodyne_viz.launch
Simultaneously visualize the synchronized velodyne pointcloud and Qualisys markers in RViz. 
Requires a bag containing the velodyne data and another containing the qualisys data.
The provided RViz configs work with our .bag files. 
Modify the RViz configs if you choose to modify the message types using the provided `mat2ROS` script. 

Example usage (terminal): 

```roslaunch useful_launch rosbag_velodyne_viz.launch bag_file:=workspace/DATA/RudenkoHumanTracking/ex1_run1.bag bag_file2:=workspace/DATA/RudenkoHumanTracking/Ex1_run1_qualisys.bag --screen```


