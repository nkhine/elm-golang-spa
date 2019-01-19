build:
	${GOPATH}/bin/dep ensure
	env GOOS=linux go build -o ./bin/status ./lib/status/main.go
	elm-app build

init:
	${GOPATH}/bin/dep init -v

test:
	env GOOS=linux go test -v ./lib/status

strip:
	strip ./bin/status

clean:
	rm -rf ./bin/status build

local: clean build strip
	docker-compose up

domain:
	sls create_domain --stage ${stage} --region eu-west-2

deploy: clean build strip
	sls deploy --stage ${stage} --region eu-west-2 --aws-profile ${profile} --verbose
