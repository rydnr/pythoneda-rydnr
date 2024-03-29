from PythonEDA.primary_port import PrimaryPort
from PythonEDAGitRepositories.git_repo_found import GitRepoFound

import argparse
import logging


class GitRepoFoundCli(PrimaryPort):

    """
    A PrimaryPort that sends GitRepoFound events specified from the command line.
    """
    def priority(self) -> int:
        return 100

    async def accept(self, app):

        parser = argparse.ArgumentParser(
            description="Sends the git repository for a given Python package"
        )
        parser.add_argument("type", choices=['git_repo_found'], nargs='?', default=None, help="The type of event to send")
        parser.add_argument("packageName", help="The name of the Python package")
        parser.add_argument("packageVersion", help="The version of the Python package")
        parser.add_argument("url", help="The url of the git repository")
        parser.add_argument("tag", help="The tag for the package version in the git repository")
        parser.add_argument("subfolder", help="The subfolder in the git repository in case of monorepo")
        parser.add_argument("-s", "--server_url", required=True, help="The server url")
        args, unknown_args = parser.parse_known_args()

        if args.type == "git_repo_found":
            event = GitRepoFound(args.packageName, args.packageVersion, args.url, args.tag, {}, args.subfolder)
            logging.getLogger(__name__).debug(f"Notifying the url of the git repository of {event.package_name}-{event.package_version} is {args.url}, under tag {args.tag}")
            await app.accept(event)
