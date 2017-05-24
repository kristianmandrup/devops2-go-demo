# run unit tests in test swarm cluster
eval $(dm env swarm-test-1)

# run on unit tests and remove
docker-compose -f docker-compose-test-local-no-extends.yml \
  run --rm unit

# build app
docker-compose -f docker-compose-test-local-no-extends.yml \
  build app

# New deployment way
# http://blog.terranillius.com/post/composev3_swarm/
# Had to upgrade version: 3 and flatten layout (no extends allowed)
docker stack deploy up -c docker-compose-test-local-no-extends.yml

# run staging and remove
docker-compose -f docker-compose-test-local.yml \
  run --rm staging

WARNING: The HOST_IP variable is not set. Defaulting to a blank string.
=== RUN   TestIntegrationTestSuite
=== RUN   Test_Hello_ReturnsStatus200
--- FAIL: Test_Hello_ReturnsStatus200 (4.29s)
        Error Trace:    integration_test.go:48
	Error:      	Received unexpected error:
	            	Get http://staging-dep:8080/demo/hello: dial tcp: lookup staging-dep on 127.0.0.11:53: no such host
panic: runtime error: invalid memory address or nil pointer dereference [recovered]
	panic: runtime error: invalid memory address or nil pointer dereference
[signal 0xb code=0x1 addr=0x0 pc=0x486092]

# take services down
docker-compose -f docker-compose-test-local-no-extends.yml \
  down
