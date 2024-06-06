# exitpoint

**A container image to run one command on start, and another upon termination**

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

For an example of a synchronous (not backgrounded) command run on start, with
an exitpoint script see [examples/synchronous](examples/synchronous).

For an example of a daemon-like backgrounded process for which we care about
the exit, see [examples/wait](examples/wait).

For an example of a backgrounded process that we don't care about the exit,
see [examples/background](examples/background).

### CMD options

You can prefix your docker CMD with the following to determine how the command
will be run:

* `--bg` or `-b` - Run the command in the background, ignore its exit with
  regard to triggering exitpoint.
* `--wait` or `-w` - Run the command in the background, and if it exits before
  receiving a signal to the container, trigger the exitpoint.

### Variables

* `EXITPOINT` - Sets the path of the exitpoint script. Defaults to
  `/exitpoint.sh`.
* `ENTRYPOINT` - An optional entrypoint script to run (in addition to
  `/exitpoint-entrypoint.sh` which sets up the exit point).
* `CMD_EXIT` - Is available to the exitpoint script, and contains the exit code
  as returned from the entrypoint + docker CMD.

## Author

[Kilna, Anthony](http://github.com/kilna)
[kilna@kilna.com](mailto:kilna@kilna.com)


