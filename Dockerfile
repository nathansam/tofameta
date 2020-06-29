FROM rocker/r-base:4.0.0

RUN mkdir analysis

RUN apt-get update -qq && apt-get -y --no-install-recommends install \
  libxml2-dev \
  libcairo2-dev \
  libsqlite-dev \
  libmariadbd-dev \
  libmariadbclient-dev \
  libpq-dev \
  libssh2-1-dev \
  unixodbc-dev \
  libsasl2-dev \
  libgsl0-dev \
  && install2.r --error \
    --deps TRUE \
    meta \
    metafor
WORKDIR /analysis
COPY . /analysis
CMD Rscript R/analysis.R
