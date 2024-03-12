def "nu-complete unwindctl log" [] {
  [
    {value: "brief" description: "Disable verbose logging"}
    {value: "verbose" description: "Enable verbose logging"}
    {value: "debug" description: "Enable ivery noisy debug logging"}
  ]
}
def "nu-complete unwindctl status" [] {
  [
    {value: "autoconf" description: "Show nameservers learned from dhcpleased(8) or slaacd(8)"}
    {value: "memory" description: "Show memory consumption"}
  ]
}

# Set the log level
export extern log [
  level: string@"nu-complete unwindctl log"       # Specific log level to set
]

# Show status summary
export extern status [
  status?: string@"nu-complete unwindctl status"  # Type of status to show
]

# Reload the configuration file
export extern reload [
]

# The unwindctl program controls the unwind(8) daemon
export extern main [
  -s: path                 # Use socket instead of the default /dev/unwind.sock to communicate with unwind(8)
]
