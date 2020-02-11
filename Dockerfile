#
# Java 8 Runner Image
# Docker image with tools and scripts installed to support the running of Java 1.8 jar
# Expects build artifact mounted at /home/runner/app/app.jar
#

FROM adoptopenjdk/openjdk8:alpine
LABEL Maintainer="Agile Digital <info@agiledigital.com.au>"
LABEL Description="Docker image with tools and scripts installed to support the running of a Java 1.8 jar" Vendor="Agile Digital" Version="0.1"

RUN apk add --update --no-cache bash=5.0.11-r1 tzdata=2019c-r0
RUN addgroup -S -g 10000 runner
RUN adduser -S -u 10000 -h "$HOME" -G runner runner

COPY tools /home/runner/tools
RUN chmod +x /home/runner/tools/run.sh

EXPOSE 9000

# We need to support Openshift's random userid's
# Openshift leaves the group as root. Exploit this to ensure we can always write to them
# Ensure we are in the the passwd file
RUN chmod g+w /etc/passwd
RUN chgrp -Rf root /home/runner && chmod -Rf g+w /home/runner
ENV RUNNER_USER runner

USER runner:root

ENTRYPOINT ["/home/runner/tools/run.sh"]