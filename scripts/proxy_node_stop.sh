kill -INT $(ps aux | grep '[n]ode AnyProxy/bin/anyproxy --intercept --port 8090' | awk '{print $2}')