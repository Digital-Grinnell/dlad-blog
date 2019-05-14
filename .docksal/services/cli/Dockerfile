# Use a stock Docksal image as the base
FROM docksal/cli:2.1-php7.1

## Install hugo 0.34
#RUN wget -q https://github.com/gohugoio/hugo/releases/download/v0.34/hugo_0.34_Linux-64bit.deb -O /tmp/hugo.deb \
#    && dpkg -i /tmp/hugo.deb

# Install hugo 0.51
RUN wget -q https://github.com/gohugoio/hugo/releases/download/v0.51/hugo_0.51_Linux-64bit.deb -O /tmp/hugo.deb \
    && dpkg -i /tmp/hugo.deb
