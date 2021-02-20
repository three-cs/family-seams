FROM amazon/aws-cli:2.1.15

RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN yum install jq -y

WORKDIR /scripts

COPY ./register-domain.bash ./register-domain.bash

RUN chmod -R 755 /scripts

ENTRYPOINT [ "bash" ]
CMD [ "" ]

