all: deps
	mix compile

rm:
	rm -rf _build/ deps

deps:
	mix deps.get

test: deps
	mix test

clean: rm
	mix clean
