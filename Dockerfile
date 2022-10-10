FROM ubuntu:22.04
ENV TZ=UTC
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /root
RUN apt update \
  && apt install --assume-yes \
    python3 python3-pip python3-ipython python3-requests python3-pandas \
    python3-kubernetes python3-boto3 \
    curl wget bash git sqlite jq parallel unzip \
    nmap inetutils-ping net-tools apt-file bind9-dnsutils
# install aws cli v2:
RUN curl --tlsv1.3 --ssl-reqd --location \
    "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
  && unzip awscliv2.zip \
  && ./aws/install \
  && rm --recursive ./aws awscliv2.zip \
  && echo "complete -C '/usr/bin/aws_completer' aws" >> ~/.bashrc
# install aws-iam-authenticator for using kubectl
RUN curl --tlsv1.2 --ssl-reqd --location --output /usr/local/bin/aws-iam-authenticator \
    https://s3.us-west-2.amazonaws.com/amazon-eks/1.21.2/2021-07-05/bin/linux/amd64/aws-iam-authenticator \
   && chmod +x /usr/local/bin/aws-iam-authenticator \
   && aws-iam-authenticator version
# install kubectl
RUN curl --tlsv1.3 --ssl-reqd --location --output /usr/local/bin/kubectl \
     https://storage.googleapis.com/kubernetes-release/release/v1.23.7/bin/linux/amd64/kubectl \
  && chmod +x /usr/local/bin/kubectl \
  && kubectl version --client=true
# install kustomize
RUN curl --tlsv1.3 --ssl-reqd --location \
    "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv4.5.7/kustomize_v4.5.7_linux_amd64.tar.gz" \
    | tar --extract --gzip \
  && install --target-directory=/usr/local/bin kustomize \
  && rm kustomize
CMD echo "Going to sleep via: tail -f /dev/null"; tail -f /dev/null
