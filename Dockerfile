FROM alpine/git
COPY . /data
WORKDIR /data
RUN rm -rf themes/*
RUN git clone https://github.com/digitalcraftsman/hugo-minimalist-theme.git themes/hugo-minimalist-theme

##

FROM skyscrapers/hugo:0.48
# FROM skyscrapers/hugo:0.46
COPY --from=0 /data /data
WORKDIR /data
RUN hugo

##

FROM mysocialobservations/docker-tdewolff-minify
COPY --from=1 /data/public /data/public
WORKDIR /data
RUN minify --recursive --verbose \
        --match=\.*.js$ \
        --type=js \
        --output public/ \
        public/

WORKDIR /data
RUN minify --recursive --verbose \
        --match=\.*.css$ \
        --type=css \
        --output public/ \
        public/

WORKDIR /data
RUN minify --recursive --verbose \
        --match=\.*.html$ \
        --type=html \
        --output public/ \
        public/

##

FROM nginx:alpine
COPY --from=2 /data/public /usr/share/nginx/html
