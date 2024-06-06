FROM bitnami/kong

### Change user to perform privileged actions
USER 0
### Install 'vim'
RUN apt update
RUN apt install unzip -y
RUN luarocks install lua-resty-openidc --check-lua-versions
### Revert to the original non-root user

USER 1001