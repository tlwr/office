ARG ruby_version
FROM ruby:$ruby_version

RUN apk add --no-cache build-base ruby-dev sqlite sqlite-dev nodejs npm yarn

RUN mkdir -p /opt/office/app
WORKDIR /opt/office/app

COPY $PWD/Gemfile .
COPY $PWD/Gemfile.lock .

RUN bundle install

COPY $PWD .

ENTRYPOINT ["make", "run"]
