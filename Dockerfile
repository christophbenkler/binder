FROM openjdk:11-jdk

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y python3-pip sl cmatrix sqlite vim emacs elinks w3m links nano man yelp ncdu less traceroute host whois telnet cowsay youtube-dl nasm btrfs-progs zsh fish
RUN pip3 install --no-cache-dir rise nbgitpuller jupyterlab

USER root

# Download the kernel release
RUN curl -L https://github.com/SpencerPark/IJava/releases/download/v1.3.0/ijava-1.3.0.zip > ijava-kernel.zip

# Unpack and install the kernel
RUN unzip ijava-kernel.zip -d ijava-kernel \
  && cd ijava-kernel \
  && python3 install.py --sys-prefix

# Set up the user environment

ENV NB_USER jovyan
ENV NB_UID 1000
ENV HOME /home/$NB_USER

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid $NB_UID \
    $NB_USER

COPY . $HOME
RUN chown -R $NB_UID $HOME

USER $NB_USER

# Launch the notebook server
WORKDIR $HOME
CMD ["jupyter", "notebook", "--ip", "0.0.0.0"]
