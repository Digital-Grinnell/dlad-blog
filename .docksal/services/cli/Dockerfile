# Use a stock Docksal image as the base
FROM docksal/cli:2.1-php7.1

## Install hugo 0.55.6
RUN wget -q https://github.com/gohugoio/hugo/releases/download/v0.55.6/hugo_0.55.6_Linux-64bit.deb -O /tmp/hugo.deb \
    && dpkg -i /tmp/hugo.deb
