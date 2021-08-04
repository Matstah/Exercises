Note to myself:

## Merge conflicts
1. If there are changes in the working directory’s stage area for the current project.
2. Conflict between the local branch and the branch being merged.

### helpfull commands to resolve conflicts
* `git log --merge`: produces list of commits that are causing the conflict.
* `git diff`: identify the differences between the states repositories or files.


## Update my fork with original
* `git fetch upstream`: Fetch the branches and their respective commits from the upstream repository. Commits to `BRANCHNAME` will be stored in the local branch `upstream/BRANCHNAME`.
* `git merge upstream/main`: Merge the changes from the upstream default branch - in this case, upstream/main - into your local default branch. This brings your fork's default branch into sync with the upstream repository, without losing your local changes.
