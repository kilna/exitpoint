ARG base_image=alpine

FROM alpine AS install

ARG base_image

COPY exitpoint*.sh install.sh /

RUN . /install.sh ${base_image}

FROM ${base_image}

COPY --from=install /install /

# tini makes sure signal handling is good, -g makes sure subprocesses inherit
# parent process signals
ENTRYPOINT [ "/sbin/tini", "-g", "--", "/exitpoint-entrypoint.sh" ]

# Set to a valid script if you want to run your own entrypoint in a
# derived container; /exitpoint-entrypoint.sh will in turn call this entrypoint
ENV ENTRYPOINT=''

# Set to another path if you want a different exitpoint location in your
# derived container
ENV EXITPOINT=/exitpoint.sh

# Default of no initial command to run; only the exitpoint will be executed
# Set CMD in your derived container (with optional --wait or --background
# prefix) in order to run a command at start of the container too.
CMD []

