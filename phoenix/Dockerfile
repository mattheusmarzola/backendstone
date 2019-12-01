FROM elixir:latest

RUN apt-get update -y 
RUN apt-get install -y inotify-tools

RUN mix local.hex --force

RUN mix archive.install --force hex phx_new 1.4.11

RUN mix local.rebar --force

#RUN mkdir /app
#COPY ./app /app
WORKDIR /app
