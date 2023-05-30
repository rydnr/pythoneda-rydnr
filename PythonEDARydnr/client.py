from PythonEDA.event import Event
from PythonEDA.event_listener import EventListener
from PythonEDA.ports import Ports
from PythonEDAGitRepositories.git_repo_found import GitRepoFound
from PythonEDARydnr.server import Server

import logging
from typing import List, Type

class Client(EventListener):

    @classmethod
    def supported_events(cls) -> List[Type[Event]]:
        """
        Retrieves the list of supported event classes.
        """
        return [ GitRepoFound ]


    @classmethod
    def listenGitRepoFound(cls, event: GitRepoFound):

        server = Ports.instance().resolve(Server)
        return server.acceptGitRepoFound(event)
