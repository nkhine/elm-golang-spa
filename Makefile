build:
	${GOPATH}/bin/dep ensure
	env GOOS=linux go build -o ./bin/status ./lib/status/main.go
	env GOOS=linux go build -o ./bin/resize ./lib/status/main.go
	env GOOS=linux go build -o ./bin/graphql ./lib/graphql/main.go
	yaml2json < src/api/spec.yml > public/docs/spec.json
	elm-app build

init:
	${GOPATH}/bin/dep init -v

test:
	env GOOS=linux go test -v ./lib/status

strip:
	strip ./bin/*

clean:
	rm -rf ./bin/* build ./public/api/spec.json

local: clean build strip
	docker-compose up

domain:
	sls create_domain --stage ${stage} --region eu-west-1

deploy: clean build strip
	sls deploy --stage ${stage} --region eu-west-1 --aws-profile ${profile} --verbose

remove: clean
	sls remove --stage ${stage} --region eu-west-1 --aws-profile ${profile} --verbose