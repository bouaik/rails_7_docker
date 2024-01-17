FROM ruby:3.2.2
RUN apt-get update -qq && apt-get install -y postgresql-client \
    && curl -sSL https://deb.nodesource.com/setup_20.x | bash - \
    && curl -sSL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update && apt-get install -y --no-install-recommends nodejs yarn

WORKDIR /myapp

COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install

# COPY package.json /myapp/package.json
# COPY yarn.lock /myapp/yarn.lock
# RUN yarn install

COPY . /myapp

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

ENV RAILS_ENV production

CMD rails db:migrate && rails s -b 0.0.0.0