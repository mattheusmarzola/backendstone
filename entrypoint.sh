#!/bin/sh

mix deps.get

mix ecto.create
mix ecto.migrate

mix test

iex -S mix phx.server