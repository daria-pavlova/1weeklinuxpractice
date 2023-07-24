#!/usr/bin/python3
import json
from http.server import BaseHTTPRequestHandler, HTTPServer


class MyRequestHandler(BaseHTTPRequestHandler):
    def _set_response(self):
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.end_headers()

    def _get_filtered_headers(self):
        headers = {
            header: value
            for header, value in self.headers.items()
            if header.startswith('R')
        }
        return headers

    def do_GET(self):
        self._set_response()
        headers = self._get_filtered_headers()

        # Add headers to the response
        for header, value in headers.items():
            self.send_header(header, value)
        self.end_headers()

        headers_json = json.dumps(headers).encode()
        self.wfile.write(headers_json)

    def do_HEAD(self):
        self._set_response()
        headers = self._get_filtered_headers()

        # Add headers to the response
        for header, value in headers.items():
            self.send_header(header, value)
        self.end_headers()


def run(server_class=HTTPServer, handler_class=MyRequestHandler, port=18000):
    server_address = ('', port)
    httpd = server_class(server_address, handler_class)
    print(f'Starting server on port {port}...')
    httpd.serve_forever()


if __name__ == '__main__':
    run()

