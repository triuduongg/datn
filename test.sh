python3 -c "import netmiko; print('[+] Cài đặt Netmiko thành công!')"
cat << 'EOF' > mac_acl.py
from netmiko import ConnectHandler
PNETLAB_IP = '192.168.193.128'
s1 = {
    'device_type': 'cisco_ios_telnet',
    'host': PNETLAB_IP,
    'port': 30004,
    'username': 'admin',
    'password': 'admin123',
    'global_delay_factor': 1.5
}
s2 = {
    'device_type': 'cisco_ios_telnet',
    'host': PNETLAB_IP,
    'port': 30005,
    'username': 'admin',
    'password': 'admin123',
    'global_delay_factor': 1.5
}
s1_cmds = [
    'mac access-list extended BLOCK_MAC_S1',
    'deny any host 0011.2233.4455',
    'permit any any',
    'exit',
    'interface ethernet 0/1',
    'mac access-group BLOCK_MAC_S1 in'
]
s2_cmds = [
    'mac access-list extended BLOCK_MAC_S2',
    'deny any host aabb.ccdd.eeff',
    'permit any any',
    'exit',
    'interface ethernet 0/1',
    'mac access-group BLOCK_MAC_S2 in'
]
def run_acl(device, cmds, name):
    print(f"[*] Đang cấu hình {name} qua cổng {device['port']}...")
    try:
        net_connect = ConnectHandler(**device)
        print(net_connect.send_config_set(cmds))
        net_connect.send_command('write memory')
        net_connect.disconnect()
        print(f"[+] Hoàn thành cấu hình trên {name}\n")
    except Exception as e:
        print(f"[-] Lỗi kết nối {name}: {e}\n")
run_acl(s1, s1_cmds, "S1")
run_acl(s2, s2_cmds, "S2")
EOF
python3 mac_acl.py
