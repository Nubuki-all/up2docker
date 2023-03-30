FROM anasty17/mltb:dev

RUN git clone https://github.com/anasty17/mirror-leech-telegram-bot /usr/src/app/

WORKDIR /usr/src/app

RUN chmod 777 /usr/src/app

RUN pip3 install --no-cache-dir -r requirements.txt

COPY . .
