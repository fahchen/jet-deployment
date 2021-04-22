```bash
./clash -d .
```

```bash
export https_proxy=http://127.0.0.1:7890;export http_proxy=http://127.0.0.1:7890;export all_proxy=socks5://127.0.0.1:7890
```

```bash
# set editor
sudo update-alternatives --config editor

# make apt respect proxy
visudo

# add below
Defaults env_keep="http_proxy https_proxy all_proxy no_proxy"
```
