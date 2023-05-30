# Rydnr interactions with PythonEDA domains

This package provides code used by @rydnr to interact with other PythonEDA domains.

This package provides:
- PythonEDARydnr/client.py: Receives events from other domains.
- PythonEDARydnr/server.py: Publishes events to the outside.
- PythonEDARydnr/infrastructure/network/grpc: A gRPC server that receives events from other domains.
- PythonEDARydnr/infrastructure/cli/git_repo_found_cli.py: A PrimaryPort that sends GitRepoFound events specified from the command line.
- PythonEDARydnr/infrastructure/cli/server_url_cli.py: A PrimaryPort that configures the server url from the command line.
- PythonEDARydnr/application/rydnr.py: The PythonEDA application class.
