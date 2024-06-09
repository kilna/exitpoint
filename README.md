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

A docker image that runs an exitpoint.sh script when terminated.

## Usage

This image is meant primarily to be a base image that will be derived from,
see the example Dockerfiles.

### Examples

* [Run nothing on start, exitpoint script on termination](https://github.com/kilna/exitpoint/tree/main/examples/exit-only)
* [Synchronous (not backgrounded) command on start, with exitpoint](https://github.com/kilna/exitpoint/tree/main/examples/synchronous)
* [Backgrounded start process, with exitpoint](https://github.com/kilna/exitpoint/tree/main/examples/background)

### Dockerfile ENV Variables

These should be set by `ENV` statements in your derived container's Dockerfile.

* `EXITPOINT` - Sets the path of the exitpoint script. Defaults to
  `/exitpoint.sh`.
* `ENTRYPOINT` - An optional entrypoint script to run by this base image's
   entrypoint script `/exitpoint-entrypoint.sh`.

### Exit Point variables

These are environment variables that are available to your exitpoint script

* `CMD_EXIT` - Contains the exit code as returned from the entrypoint + docker
   CMD.
* `SIGNAL` - Contains the name of the signal received that caused it to be
   called.

## Author

[Kilna, Anthony](http://github.com/kilna)
[kilna@kilna.com](mailto:kilna@kilna.com)


