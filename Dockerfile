# Base Image 
FROM fedora:37

# Set non interactive shell and timezone
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Africa/Lagos

# Install Dependencies
RUN dnf -qq -y update && dnf -qq -y install git aria2 bash xz wget curl pv jq python3-pip mediainfo psmisc procps-ng qbittorrent-nox && if [[ $(arch) == 'aarch64' ]]; then   dnf -qq -y install gcc python3-devel; fi && python3 -m pip install --upgrade pip setuptools

# Install latest ffmpeg
RUN arch=$(arch | sed s/aarch64/arm64/ | sed s/x86_64/64/) && \
    wget -q https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-n7.1-latest-linux${arch}-gpl-7.1.tar.xz && tar -xvf *xz && cp *7.1/bin/* /usr/bin && rm -rf *xz && rm -rf *7.1

# Copy files from repo to home directory
RUN git clone https://github.com/Nubuki-all/Enc bot && cp bot/requirements.txt . && rm -rf bot

# Install python3 requirements
RUN pip3 install -r requirements.txt

#cleanup
RUN rm requirements.txt Dockerfile && if [[ $(arch) == 'aarch64' ]]; then   dnf -qq -y history undo last; fi && dnf clean all
