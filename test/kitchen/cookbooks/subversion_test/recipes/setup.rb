

# make sure we have latest chef on the basebox
node.set['omnibus_updater']['version'] = '10.14.4-1'

include_recipe "omnibus_updater"