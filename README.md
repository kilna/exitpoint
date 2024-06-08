# exitpoint

**A container image to run an exitpoint.sh script upon termination**

[![DockerHub kilna/exitpoint](https://img.shields.io/badge/DockerHub-kilna/exitpoint-blue?logo=docker)](https://hub.docker.com/r/kilna/exitpoint)
[![Docker Image Version](https://img.shields.io/docker/v/kilna/exitpoint?sort=semver)](https://hub.docker.com/r/kilna/exitpoint)
[![Docker Image Size (tag)](https://img.shields.io/docker/image-size/kilna/exitpoint/latest)](https://hub.docker.com/r/kilna/exitpoint)
[![Docker Pulls](https://img.shields.io/docker/pulls/kilna/exitpoint?style=social)](https://hub.docker.com/r/kilna/exitpoint)
[![Docker Stars](https://img.shields.io/docker/stars/kilna/exitpoint?style=social)](https://hub.docker.com/r/kilna/exitpoint)

[![GitHub kilna/exitpoint](https://img.shields.io/badge/GitHub-kilna/exitpoint-green?logo=github)](https://github.com/kilna/exitpoint)
[![GitHub forks](https://img.shields.io/github/forks/kilna/exitpoint?style=social)](https://github.com/kilna/exitpoint/forks)
[![GitHub watchers](https://img.shields.io/github/watchers/kilna/exitpoint?style=social)](https://github.com/kilna/exitpoint/watchers)
[![GitHub Repo stars](https://img.shields.io/github/stars/kilna/exitpoint?style=social)](https://github.com/kilna/exitpoint/stargazers)

A docker image that runs /exitpoint.sh (or another path) when terminated.

## Usage

This image is meant primarily to be a base image that will be derived from,
an example Dockerfile.

### Examples

For an example of running nothing on start, and exitpoint script on termination
see [examples/exit-only](examples/exit-only).

For an example of a synchronous (not backgrounded) command run on start, with
an exitpoint script see [examples/synchronous](examples/synchronous).

For an example of a daemon-like backgrounded process for which we care about
the exit, see [examples/wait](examples/wait).

For an example of a backgrounded process that we don't care about the exit,
see [examples/background](examples/background).

### Variables

* `EXITPOINT` - Sets the path of the exitpoint script. Defaults to
  `/exitpoint.sh`.
* `ENTRYPOINT` - An optional entrypoint script to run by the base image's
   entrypoint script `/exitpoint-entrypoint.sh`.
* `CMD_EXIT` - Is available to the exitpoint script, and contains the exit code
  as returned from the entrypoint + docker CMD.

## Author

[Kilna, Anthony](http://github.com/kilna)
[kilna@kilna.com](mailto:kilna@kilna.com)


