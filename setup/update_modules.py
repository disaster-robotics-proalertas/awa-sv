#!/usr/bin/env python

import rospkg
import sys
import yaml

base_diag = '''analyzers:
  modules:
    type: diagnostic_aggregator/AnalyzerGroup
    path: Modules
    analyzers:
'''

user_modules = sys.argv[1:]

# Get param and diag file paths from ROS package
rospack = rospkg.RosPack()
try:
    param_file = rospack.get_path('asv_description') + '/param/vehicle.yaml'
    diag_file = rospack.get_path('asv_description') + '/diag/modules.yaml'
except rospkg.ResourceNotFound as exp:
    print "update_modules.py: %s package not found" % exp 
    sys.exit(1)

# Load param file as yaml
with open(param_file) as f:
    yaml_file = yaml.load(f)

# Update modules field
yaml_file['modules'] = []
for mod in user_modules:
    yaml_file['modules'].append('%s' % mod)

# Check if modules list is empty
if not yaml_file['modules']:
    yaml_file['modules'].append('')

# Save modified yaml file
with open(param_file, 'w') as f:
    yaml.dump(yaml_file, f)

with open(diag_file, 'w') as f:
    # If there are modules to include
    if len(user_modules) > 0:
        # Write diag basis to file
        f.write(base_diag)
        # Write modules
        for mod in user_modules:
            base_mod = '''      %s:
        type: diagnostic_aggregator/GenericAnalyzer
        path: %s
        timeout: 10.0
        startswith: %s
        find_and_remove_prefix: %s
''' % (mod, mod.strip('0123456789').capitalize(), mod, mod)
            f.write(base_mod)

sys.exit(0)