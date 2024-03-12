def "nu-complete vmctl ids" [] {
  ^vmctl status | detect columns | select ID NAME | rename value description
}

def "nu-complete vmctl ids_and_names" [] {
  let ids = (^vmctl status | detect columns | select ID NAME | rename value description)
  let names = (^vmctl status | detect columns | select NAME ID | rename value description)
  $ids ++ $names
}

def "nu-complete vmctl names" [] {
  ^vmctl status | detect columns | select NAME ID | rename value description
}

def "nu-complete vmctl loglevel" [] {
  [brief verbose]
}

def "nu-complete vmctl reset" [] {
  [
    { value: "all" description: "Reset running state" }
    { value: "switches" description: "Reset switches" },
    { value: "vms" description: "Reset vms" }
  ]
}

def "nu-complete vmctl devicetypes" [] {
  [
    { value: "cdrom" description: "Boot the CD-ROM image" }
    { value: "disk" description: "Boot from disk" },
    { value: "net" description: "Perform a PXE boot using the first network interface" }
  ]
}

# Using cu(1) connect to the console of the VM with the specified id
export extern console [
  id: int@"nu-complete vmctl ids"     # The ID of the vm, as shown with "vmctl status"
]

# Create a VM disk image file with the specified disk path
export extern create [
  disk: string                        # The name of the to be created disk
  -b: string                          # For ‘qcow2’, a base image may be specified. The base image is not modified and the derived image contains only the changes written by the VM.
  -i: string                          # Copy and convert the input disk to the newly created disk. This option conflicts with -b base.
  -s: string                          # Specify the size of the new disk image, rounded to megabytes. If the -b option is specified, the size must match the size of the base image. For the -i option, the size cannot be smaller than the input disk size. The size can be omitted with the -b and -i options and will be obtained from the base or input image respectively.
]

# Load additional configuration from the specified file
export extern load [
  filename: path                      # The file to load the additional configuration from.
]

# Disable or enable verbose debug logging
export extern log [
  loglevel: string@"nu-complete vmctl loglevel"   # The log level to set
]

# Pause a VM with the specified id
export extern pause [
  id: int@"nu-complete vmctl ids"     # The ID of the vm, as shown with "vmctl status"
]

# Receive a VM from standard input and start it with the specified name
export extern receive [
  name: string                        # The name to start the vm with
]

# Remove all stopped VMs and reload the configuration from the default configuration file
export extern reload []

# Reset the running state, reset switches, or reset and terminate all vms
export extern reset [
  what: string@"nu-complete vmctl reset"    # What to reset
]

# Send a VM with the specified id to standard output and terminate
# it.  The VM is paused during send processing.  Data sent to
# standard output contains the VM parameters and its memory, not
# the disk image.
# 
# In order to move a VM from one host to another, disk files must
# be synced between the send and the receive processes and must be
# located under the same path.
export extern send [
  id: int@"nu-complete vmctl ids"     # The ID of the vm, as shown with "vmctl status"
]

# An alias for the status command
export extern show [
  id?: int@"nu-complete vmctl ids"    # The ID of the vm, as shown with "vmctl status"
]

# List VMs running on the host, optionally listing just the selected VM id
export extern status [
  id?: int@"nu-complete vmctl ids"    # The ID of the vm, as shown with "vmctl status"
]

# Stop (terminate) a VM defined by the specified VM id or all
# running VMs (-a).  By default, a graceful shutdown will be
# attempted if the VM supports the vmmci(4) device
export extern stop [
  id: int@"nu-complete vmctl ids"     # The ID of the vm, as shown with "vmctl status"
  -f                                  # Forcefully stop the VM without attempting a graceful shutdown
  -w                                  # Wait until the VM has been terminated
  -a                                  # Shtudown all VMs
]

# Unpause (resume from a paused state) a VM with the specified id
export extern unpause [
  id: int@"nu-complete vmctl ids"    # The ID of the vm, as shown with "vmctl status"
]

# Wait until the specified VM has stopped
export extern wait [
  id: int@"nu-complete vmctl ids"    # The ID of the vm, as shown with "vmctl status"
]

# Start a new VM name with the specified parameters.  An existing
# VM may be started by referencing its id
export extern start [
  id: string@"nu-complete vmctl ids_and_names"
  -B: string@"nu-complete vmctl devicetypes"   # Force system to boot from the specified device for this boot. Currently net is only supported when booting a kernel using the -b flag while disk and cdrom only work with VMs booted using BIOS.
  
  -b: path                                     # Boot the VM with the specified OpenBSD kernel or custom BIOS image. If not specified, the default is to boot using the BIOS image in /etc/firmware/vmm-bios. If the VM is an existing VM, use the provided image for only the next boot.
  -c                                           # Automatically connect to the VM console
  -d: path                                     # Use a disk image at the specified disk path (may be specified multiple times to add multiple disk images)
  -i: int                                      # Number of network interfaces to add to the VM
  -L                                           # Add a local network interface. vmd(8) will auto-generate an IPv4 subnet for the interface, configure a gateway address on the VM host side, and run a simple DHCP/BOOTP server for the VM. See LOCAL INTERFACES below for more information on how addresses are calculated and assigned when using the -L option.
  -m: string                                   # Memory size of the VM, rounded to megabytes. The default is 512M
  -n: string                                   # Add a network interface that is attached to the specified virtual switch. See the SWITCH CONFIGURATION section in vm.conf(5) for more information.
  -r: path                                     # ISO image file for virtual CD-ROM. This image file will be available in the selected VM as a SCSI CD-ROM device attached to a virtio SCSI adapter (e.g. vioscsi(4)).
  -t: string@"nu-complete vmctl names"         # Use an existing VM with the specified name as a template to create a new VM instance. The instance will inherit settings from the parent VM, except for exclusive options such as disk, interface lladdr, and interface names.
]


# The vmctl utility is used to control the virtual machine monitor (VMM) subsystem
export extern main []
