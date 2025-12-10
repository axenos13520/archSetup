#!/usr/bin/env python3
import os
from http.server import BaseHTTPRequestHandler, HTTPServer

COLOR_FILE = os.path.expanduser("~/.config/cava/themes/external")


class Handler(BaseHTTPRequestHandler):
    def do_POST(self):
        length = int(self.headers.get("Content-Length", 0))
        data = self.rfile.read(length).decode("utf-8").strip()

        if not data.startswith("#") or len(data) not in (4, 7):
            self.send_response(400)
            self.end_headers()
            return

        os.makedirs(os.path.dirname(COLOR_FILE), exist_ok=True)
        with open(COLOR_FILE, "w") as f:
            f.write(
                f"""[color]
horizontal_gradient = 1
horizontal_gradient_color_1 = '#2a2328'
horizontal_gradient_color_2 = '{data}'
"""
            )

        os.system("pkill -SIGUSR2 cava")

        self.send_response(204)
        self.end_headers()

    def log_message(self, *args, **kwargs):
        return


if __name__ == "__main__":
    server = HTTPServer(("127.0.0.1", 31337), Handler)
    print("Listening on http://127.0.0.1:31337")
    server.serve_forever()
