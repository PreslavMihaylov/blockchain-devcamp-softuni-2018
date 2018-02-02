#!/usr/bin/env python

import hashlib
import sys

sha256 = hashlib.sha256()

sha256.update('Hello_World')

sha256.digest()
print(sha256.hexdigest())

