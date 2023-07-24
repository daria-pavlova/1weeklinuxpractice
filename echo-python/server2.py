from http.server import BaseHTTPRequestHandler, HTTPServer
from datetime import datetime


class MyRequestHandler(BaseHTTPRequestHandler):
    def _set_response(self, status_code=200):
        self.send_response(status_code)
        self.send_header('Content-type', 'text/plain')
        self.send_header('RPay-Signature', str(datetime.now()))
        self.end_headers()

    def do_GET(self):
        if self.path == '/health':
            self._set_response(404)
        else:
            self._set_response()
        self.wfile.write(b'Hello, World!->>>>>>>>>>>')

    def do_HEAD(self):
        self._set_response()

    def do_POST(self):
        content_length = int(self.headers.get('Content-Length', 0))
        data = self.rfile.read(content_length)

        self._set_response()
        self.wfile.write(b'Hello, World! POST request received.')
        self.wfile.write(b'\nData: ' + data)

    def do_PATCH(self):
        content_length = int(self.headers.get('Content-Length', 0))
        data = self.rfile.read(content_length)

        self._set_response()
        self.wfile.write(b'Hello, World! PATCH request received.')
        self.wfile.write(b'\nData: ' + data)


def run(server_class=HTTPServer, handler_class=MyRequestHandler, port=18000):
    server_address = ('', port)
    httpd = server_class(server_address, handler_class)
    print(f'Starting server on port {port}...')
    logging.basicConfig(stream=sys.stdout, level=logging.INFO)
    logging.info(f'Starting server on port {port}...')
    httpd.serve_forever()

if __name__ == '__main__':
    run()

