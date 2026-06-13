# Static site for scuffedcorporation.com, served by Caddy (automatic HTTPS).
FROM caddy:2-alpine

COPY Caddyfile /etc/caddy/Caddyfile

# Site assets live at the web root so the absolute paths (/styles.css, /about/) resolve.
COPY index.html 404.html styles.css favicon.svg robots.txt /srv/
COPY about/ /srv/about/
COPY projects/ /srv/projects/
COPY privacy/ /srv/privacy/
