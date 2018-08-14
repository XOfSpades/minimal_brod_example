FROM elixir:1.7.2-alpine

MAINTAINER bernhard.stoecker@recogizer.de


ARG mix_env
RUN echo Using mix env $mix_env

RUN apk add --update bash git gcc g++ make libc-dev bsd-compat-headers && rm -rf /var/cache/apk/*

RUN mix local.hex --force && \
    mix local.rebar --force

RUN mkdir /minimal_brod_example

WORKDIR /minimal_brod_example

RUN mkdir /minimal_brod_example/_build
RUN mkdir -p /minimal_brod_example/config
RUN mkdir /minimal_brod_example/lib

COPY mix.exs /minimal_brod_example/mix.exs
COPY mix.lock /minimal_brod_example/mix.lock

RUN MIX_ENV=$mix_env mix do deps.get, deps.compile

COPY config/config.exs /minimal_brod_example/config/config.exs
#COPY config/test.exs /minimal_brod_example/config/test.exs
#COPY config/dev.exs /minimal_brod_example/config/dev.exs
#COPY config/prod.exs /minimal_brod_example/config/prod.exs

COPY lib /minimal_brod_example/lib

RUN MIX_ENV=$mix_env mix compile
