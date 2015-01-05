FROM ruby:latest
RUN apt-get update
RUN gem install slack-notify
RUN gem install rest-client
ADD ./recent.rb /slack/
ADD ./config.yaml /slack/
WORKDIR /slack/
CMD ["ruby", "recent.rb"]
