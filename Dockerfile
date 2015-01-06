FROM ruby:latest
RUN apt-get update
RUN gem install slack-notify
RUN gem install rest-client
ENV LOCALE en_US.UTF-8
ADD ./recent.rb /slack/
ADD ./parents.rb /slack/
ADD ./config.yaml /slack/
WORKDIR /slack/
CMD ["ruby", "recent.rb"]
