# Base Image 
FROM fedora:40

# Set non interactive shell and timezone
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Africa/Lagos

# Install Dependencies
RUN dnf -qq -y update && dnf -qq -y install git bash xz wget curl pv jq python3-pip psmisc procps-ng && if [[ $(arch) == 'aarch64' ]]; then   dnf -qq -y install gcc python3-devel; fi && python3 -m pip install --upgrade pip setuptools

# Install latest ffmpeg
RUN arch=$(arch | sed s/aarch64/arm64/ | sed s/x86_64/64/) && \
    wget -q https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-n7.1-latest-linux${arch}-gpl-7.1.tar.xz && tar -xvf *xz && cp *7.1/bin/* /usr/bin && rm -rf *xz && rm -rf *7.1

# Install postgresql repo & latest postgresql 
RUN dnf -qq -y install "https://download.postgresql.org/pub/repos/yum/reporpms/F-$(. /etc/os-release; echo $VERSION_ID)-x86_64/pgdg-fedora-repo-latest.noarch.rpm"
RUN dnf -qq -y install postgresql17-server
#Test command availability 
RUN pg_dump

# Copy files from repo to home directory
RUN git clone https://github.com/Nubuki-all/neon_bot bot && cp bot/requirements.txt . && rm -rf bot

# Install python3 requirements
RUN pip3 install -r requirements.txt

#cleanup
RUN rm requirements.txt && if [[ $(arch) == 'aarch64' ]]; then   dnf -qq -y history undo last; fi && dnf clean all
