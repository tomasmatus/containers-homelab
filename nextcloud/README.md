# Nextcloud custom config

- https://docs.nextcloud.com/server/stable/admin_manual/configuration_server/config_sample_php_parameters.html#introduction

This can be used instead of the `occ` command to configure some nextcloud options.

# Configure nextcloud to use imaginary for image previews

- https://help.nextcloud.com/t/how-to-generate-image-previews-in-nextcloud-with-imaginary-with-docker/228822

Edit config.php manually or issue command in host to enable preview generation adjusting the value
to your docker service IP-address including the configured docker port: <http://imaginary.docker.service.ip:port>

```
occ config:system:set preview_imaginary_url --value="http://imaginary.docker.service.IP:9000"
```

and edit config.php manually or issue command in host to enable imaginary

```
occ config:system:set enabledPreviewProviders 0 --value="OC\\Preview\\Imaginary"
```

Add an array of preview file types if desired.

# Euro-Office setup

- https://nextcloud.com/blog/how-to-install-euro-office/#variant-b-install-the-euro-office-document-server-via-docker

# Configure syslog logging

- https://docs.nextcloud.com/server/stable/admin_manual/configuration_server/config_sample_php_parameters.html#logfile

Use this when syslog server is running in homelab.

# Valkey

- https://valkey.io/topics/cli/

To monitor what is valkey doing use one of the following:
```
valkey-cli MONITOR
valkey-cli --stat
```
