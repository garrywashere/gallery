ARG  BASE_IMAGE=ruby:3.1.3-alpine3.17
FROM ${BASE_IMAGE}

RUN apk update && apk upgrade && \
    apk add --no-cache \
    build-base \
    glib-dev \
    exiftool \
    libexif-dev \
    expat-dev \
    tiff-dev \
    jpeg-dev \
    libpng \
    libgsf-dev \
    vips \
    git \
    rsync \
    lftp \
    openssh \
    perl \
    imagemagick \
    imagemagick-dev && \
    rm -rf /var/cache/apk/*

WORKDIR /photo-stream

COPY Gemfile Gemfile.lock ./

RUN gem install bundler jekyll && \
    bundle config --local build.sassc --disable-march-tune-native && \
    bundle install

COPY . .

EXPOSE 4000

ENTRYPOINT ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0"]