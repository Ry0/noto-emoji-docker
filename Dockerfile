FROM python:3.8
USER root

RUN apt-get update
RUN apt-get -y install locales && \
    localedef -f UTF-8 -i ja_JP ja_JP.UTF-8
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8
ENV TZ JST-9
ENV TERM xterm

RUN apt-get install -y zopfli libcairo2-dev imagemagick pngquant
RUN pip install --upgrade pip
RUN pip install --upgrade setuptools

RUN git clone -b v2019-11-19-unicode12 https://github.com/googlefonts/noto-emoji.git
RUN git clone -b v0.2.17 https://github.com/googlefonts/nototools.git

RUN cd nototools &&\
    pip install -r requirements.txt &&\
    python setup.py develop

RUN cd noto-emoji/ &&\
    rm png/128/emoji_u002a* png/128/emoji_u0023* png/128/emoji_u003* &&\
    mv NotoColorEmoji.tmpl.ttx.tmpl NotoColorEmoji.tmpl.ttx.tmpl.bak &&\
    sed -e 's/".notdef" width="2550"/".notdef" width="680"/g' \
    -e 's/"nonmarkingreturn" width="2550"/"nonmarkingreturn" width="680"/g' \
    -e 's/"space" width="2550"/"space" width="680"/g' \
    -e 's/".notdef" height="2500"/".notdef" height="680"/g' \
    -e 's/"nonmarkingreturn" height="2500"/"nonmarkingreturn" height="680"/g' \
    -e 's/"space" height="2500"/"space" height="680"/g' \
    -e 's/underlinePosition value="-1244"/underlinePosition value="-300"/g' \
    NotoColorEmoji.tmpl.ttx.tmpl.bak > NotoColorEmoji.tmpl.ttx.tmpl &&\
    make -j