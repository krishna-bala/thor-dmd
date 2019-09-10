## A package providing utilities for the THÖR dataset.

### Description of Script and Launch files. 

#### get_transform.m
Calculates and returns Translation and RPY vectors for the Velodyne frame w.r.t the Qualisys frame.

Example usage (MATLAB):`[T, R] = get_transform('Ex_1_run_1.mat')`

where 'Ex_1_run_1.mat' is the .mat file containing the Qualisys tracks from Experiment 1, run 1.
Returned values: `T` is the translation vector and `R` is the RPY vector of the Velodyne frame.


#### mat2ROS.m
Publishes all tracked Qualisys trajectories as ROS messages (geometry_msgs/PoseStamped).
Doesn't replay messages from .mat file. It plays it out. Record them and use other scripts and launch files to properly play them.

You probably don't need this file unless you wish to change the message type of the tracked objects.

Example usage (MATLAB):`mat2ROS('Ex_1_run_1.mat')`

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

```roslaunch thor_velodyne_utils rosbag_velodyne_viz.launch velodyne_bag_file:=workspace/DATA/RudenkoHumanTracking/ex1_run1.bag qualisys_bag_file:=workspace/DATA/RudenkoHumanTracking/Ex1_run1_qualisys.bag --screen```

Arguments to roslaunch:
1. `velodyne_bag_file`: relative path from your HOME folder of a bag containing the velodyne_packets topic.
2. `qualisys_bag_file`: relative path from your HOME folder of a bag containing the Qualisys tracks as geometry_msgs/PointStamped messages. 


### Description of bag files

#### Velodyne bag files

Each velodyne bag contains messages of type `velodyne_msgs/VelodyneScan` under the topic `velodyne_packets`.
An launch file is provided in the `thor_velodyne_utils` package that is an example of how the data can be unpacked and visualized in the ROS framework.   
There are additional messages in the bag that can be safely ignored.

#### Qualisys bag files

Each Qualisys bag contains 12 topics each containing `geometry_msgs/PoseStamped` messages.
The topic names are related to rigid bodies tracked by the Qualisys system. 
These mappings are provided below:

| Qualisys object | Topic name |
|-----------------|------------|
| Helmet 2        | object_3   |
| Helmet 3        | object_4   |
| Helmet 4        | object_5   |
| Helmet 5        | object_6   |
| Helmet 6        | object_7   |
| Helmet 7        | object_8   |
| Helmet 8        | object_9   |
| Helmet 9        | object_10  |
| Helmet 10       | object_11  |
| Velodyne LIDAR  | object_12  |
| Robot           | object_13  | 
 
