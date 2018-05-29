all: build

build:
	mix deps.get && mix escript.build

