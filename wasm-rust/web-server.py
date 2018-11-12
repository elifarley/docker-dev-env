#!/bin/env python2.7
import SimpleHTTPServer
import SocketServer

PORT = 8000

class Handler(SimpleHTTPServer.SimpleHTTPRequestHandler):
    pass

Handler.extensions_map['.wasm'] = 'application/wasm'

httpd = SocketServer.TCPServer(("", PORT), Handler)

print "Serving at port", PORT
httpd.serve_forever()
