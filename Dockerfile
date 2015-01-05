FROM ruby:latest
RUN apt-get update
RUN gem install slack-notify
RUN gem install rest-client
#RUN DEBIAN_FRONTEND=noninteractive apt-get install -qqy --no-install-recommends \
ADD ./recent.rb /slack/
CMD ["ruby", "/slack/recent.rb"]
