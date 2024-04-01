
zip: build
	zip -jrm build/bootstrap.zip build/bin/bootstrap

clean:
	rm -rf build/

build: clean
	GOOS=linux GOARCH=amd64 CGO_ENABLED=1 go build -v -ldflags '-d -s -w' -a -tags netgo -installsuffix netgo -o build/bin/bootstrap .