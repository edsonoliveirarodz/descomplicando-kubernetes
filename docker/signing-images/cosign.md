# How to install - Cosing
### Site: https://docs.sigstore.dev/cosign/system_config/installation/

### Generates a key-pair:
```
cosign generate-key-pair
```

### Sign the supplied container image:
```
cosign sign -key consign.key <YOUR-IMAGE>
```

### Verify a signature on the supplied container image:
```
cosign verify --key cosign.pub <YOUR-IMAGE>
```