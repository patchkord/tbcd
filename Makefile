rm:
	rm -rf _build/ deps

deps:
	mix deps.get

test: deps
	mix eunit
