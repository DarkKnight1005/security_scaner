ps aux | grep "[n]ode $PWD/AnyProxy/bin/anyproxy --intercept --port 8090" | awk '{print $2}' | wc -l