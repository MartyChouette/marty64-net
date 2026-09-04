import http.server, socketserver
PORT = 9100
class H(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        # Force the browser to always re-fetch — no stale wasm/js/pak.
        self.send_header('Cache-Control', 'no-store, no-cache, must-revalidate, max-age=0')
        self.send_header('Pragma', 'no-cache')
        self.send_header('Expires', '0')
        super().end_headers()
with socketserver.TCPServer(("", PORT), H) as httpd:
    print(f"no-cache server on http://localhost:{PORT}/index.html")
    httpd.serve_forever()
