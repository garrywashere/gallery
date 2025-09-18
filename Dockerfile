FROM ruby:3.1.3-alpine3.17 AS builder

RUN apk add --no-cache --virtual .build-deps \
    build-base git \
    && apk add --no-cache \
    glib-dev \
    exiftool \
    libexif-dev \
    expat-dev \
    tiff-dev \
    jpeg-dev \
    libpng \
    libgsf-dev \
    vips \
    perl \
    imagemagick

WORKDIR /photo-stream

COPY Gemfile Gemfile.lock ./

RUN gem install --no-document bundler jekyll && \
    bundle config set --local build.sassc --disable-march-tune-native && \
    bundle install --without development test --jobs=$(nproc) && \
    rm -rf /usr/local/bundle/cache/*

COPY . .

RUN apk del .build-deps && \
    rm -rf /var/cache/apk/*

CMD ["bundle", "exec", "jekyll", "build", "--destination", "/photo-stream/_site"]
