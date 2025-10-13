#!/bin/bash

# Di Elrond:

# 1. Test koneksi
curl http://www.k38.com/app/
curl http://www.k38.com/static/

# 2. Load testing
ab -n 500 -c 10 http://www.k38.com/app/
ab -n 500 -c 10 http://www.k38.com/static/
Di Sirion (untuk troubleshooting):
bash
# Cek nginx process
ps aux | grep nginx

# Test config
nginx -t

# Cek error log
tail -f /var/log/nginx/error.log
Di Lindon & Vingilot (untuk troubleshooting):

# Cek service running
ps aux | grep nginx
ps aux | grep php

# Cek error log
tail -f /var/log/nginx/error.log
