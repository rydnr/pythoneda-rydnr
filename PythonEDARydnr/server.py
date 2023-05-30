from PythonEDA.port import Port
from PythonEDAGitRepositories.git_repo_found import GitRepoFound

class Server(Port):

    def __init__(self):
        super().__init__()

    def acceptGitRepoFound(self, event: GitRepoFound):
        """
        Accepts a GitRepoFound event.
        """
        raise NotImplementedError("acceptGitRepoFound() not implemented by the subclass")
