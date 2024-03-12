def "nu-complete dhcpleasectl interfaces" [] {
  ifconfig | grep -E '^[a-zA-Z0-9]+:' | lines | str replace -r ":.*$" ""
}

# The dhcpleasectl program instructs dhcpleased(8) daemon to request a new lease
export extern main [
  interface: string@"nu-complete dhcpleasectl interfaces" # Use the specified interface
  -l                       # List the configured lease on interface instead of requesting a new lease
  -s: path                 # Use socket instead of the default /dev/dhcpleased.sock to communicate with dhcpleased(8)
  -w: number               #  Specify the maximum number of seconds to wait for interface to be configured.  The default is to wait 10 seconds unless -l is specified.
]

