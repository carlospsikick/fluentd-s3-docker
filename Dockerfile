FROM fluent/fluentd:v1.14-debian-1
# Use root account to use apk
USER root
RUN buildDeps="sudo make gcc g++ libc-dev" \
 && apt-get update \
 && apt-get install -y --no-install-recommends $buildDeps \
 && sudo gem install fluent-plugin-s3 --no-document \
 && sudo gem sources --clear-all \
 && SUDO_FORCE_REMOVE=yes \
    apt-get purge -y --auto-remove \
                  -o APT::AutoRemove::RecommendsImportant=false \
                  $buildDeps \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem
RUN mkdir -p /var/log/fluent/data
RUN chown fluent:fluent /var/log/fluent/data
USER fluent
COPY fluentd/flow.conf /fluentd/etc/fluent.conf
