pacman -Syy
pacman -S zsh grml-zsh-config sudo
useradd -m -G wheel -s /bin/zsh clouds
passwd clouds
visudo # /wheel

echo linode-jp > /etc/hostname

pacman -S shadowsocks
cat << _EOF_ > /etc/shadowsocks/linode.json
{
    "server":"::",
    "server_port":1304,
    "local_address": "127.0.0.1",
    "local_port":1080,
    "password":"<password>",
    "timeout":300,
    "method":"aes-256-cfb",
    "fast_open": false,
    "workers": 1
}
_EOF_
systemctl start shadowsocks-server@linode
systemctl enable shadowsocks-server@linode

vim /etc/sshd_config # GatewayPorts clientspecified
