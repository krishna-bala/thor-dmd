import sys
import rosbag
import time
import subprocess
import yaml
import rospy
import os
import argparse
import math
import tqdm
from shutil import move

def status(length, percent):
  sys.stdout.write('\x1B[2K') # Erase entire current line
  sys.stdout.write('\x1B[0E') # Move to the beginning of the current line
  progress = "Progress: ["
  for i in range(0, length):
    if i < length * percent:
      progress += '='
    else:
      progress += ' '
  progress += "] " + str(round(percent * 100.0, 2)) + "%"
  sys.stdout.write(progress)
  sys.stdout.flush()


def main(args):
  parser = argparse.ArgumentParser(description='Reorder a bagfile based on header timestamps.')
  parser.add_argument('bagfile', nargs=1, help='input bag file')
  args = parser.parse_args()
    
  # Get bag duration  
  
  bagfile = args.bagfile[0]
  
  orig = os.path.splitext(bagfile)[0] + ".orig.bag"
  
  move(bagfile, orig)
  
  with rosbag.Bag(bagfile, 'w') as outbag:
    for topic, msg, t in tqdm.tqdm(rosbag.Bag(orig).read_messages(), total=rosbag.Bag(orig).get_message_count()):
          
      # This also replaces tf timestamps under the assumption 
      # that all transforms in the message share the same timestamp
      if topic == "/tf" and msg.transforms:
        outbag.write(topic, msg, msg.transforms[0].header.stamp - rospy.Duration(1))
      elif msg._has_header:
        outbag.write(topic, msg, msg.header.stamp)
      else:
        outbag.write(topic, msg, t)
  print "\ndone"

if __name__ == "__main__":
  main(sys.argv[1:])
