.PHONY: all

all:
	docker run --rm -v $$PWD:/work -w /work mcr.microsoft.com/dotnet/sdk:9.0 bash -c \
		"dotnet build --configuration Release && time bin/Release/net9.0/day07 < input.txt"
