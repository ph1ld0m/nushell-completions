def "nu-complete hx grammar" [] {
  [fetch build]
}

def "nu-complete hx health" [] {
  hx --health languages | from ssv | where Language !~ '^✘' | get Language | prepend [all clipboard languages] 
}

# The helix-editor
export extern main [
  files?: path                                     # The file paths to open
  --help(-h)                                       # Prints help information
  --tutor                                          # Loads the tutorial
  --health: string@"nu-complete hx health"         # Checks for potential erros in editor setup
  --grammar(-g): string@"nu-complete hx grammar"   # Fetches or builds tree-sitter grammars listed in languages.toml
  --config(-c): path                               # Specifies a file to use for configuration
  -v                                               # Increases logging verbosity each use for up to 3 times
  --log: path                                      # Specifies a file to use for logging (default file: /home/dal/.cache/helix/helix.log)
  --version(-V)                                    # Prints version information
  --vsplit                                         # Splits all given files vertically into different windows
  --hsplit                                         # Splits all given files horizontally into different windows
  --working-dir(-w): path                          # Specify an initial working directory
]
