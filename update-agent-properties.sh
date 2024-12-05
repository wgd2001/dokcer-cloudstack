#!/bin/bash

# ???? UUID
local_uuid=$(uuidgen)
guid=$(uuidgen)
# ?? agent.properties ????
agent_properties="/etc/cloudstack/agent/agent.properties"

# ?? agent.properties ????
if [[ ! -f "$agent_properties" ]]; then
  echo "Error: $agent_properties not found!"
  exit 1
fi


# ?? sed ?? Local.storage.uuid ? guid
sed -i 's/cloudbr0/eth0/g' "$agent_properties"
sed -i "s/^local.storage.uuid=.*/local.storage.uuid=$local_uuid/" "$agent_properties"
sed -i "s/^guid=.*/guid=$guid/" "$agent_properties"

# ?? local.storage.path ? guest.cpu.features ??
# ?? echo ? tee ????????,????????
#echo "local.storage.path=/var/lib/libvirt/images" | tee -a "$agent_properties" > /dev/null
#echo "guest.cpu.features=vmx ept aes smx mmx ht" | tee -a "$agent_properties" > /dev/null

# ??????
echo "Updated $agent_properties:"
grep -E "Local.storage.uuid|guid|local.storage.path|guest.cpu.features" "$agent_properties"

