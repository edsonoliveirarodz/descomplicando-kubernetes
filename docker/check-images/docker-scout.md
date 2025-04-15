# How to install - Docker scout
### Site: https://docs.docker.com/scout/install/

### Usage example
#### Display CVEs identified in a software artifact:
```
docker scout cves <YOUR-IMAGE>
```

### Display available base image updates and remediation recommendations:
```
docker scout recommendations <YOUR-IMAGE>
```

### Compare two images and display differences:
```
docker scout compare --to <YOUR-IMAGE-1> <YOUR-IMAGE-2>
```