# Samba 文件服务配置

本文档说明如何在 NixOS 中配置和使用 Samba 文件服务器。

## 🚀 快速开始

### 1. 启用 Samba 服务

Samba 服务配置已包含在 `system/services/samba.nix` 中，默认启用。运行以下命令应用配置：

```bash
sudo nixos-rebuild switch
# 或使用 nh 工具
sudo nh os switch
```

### 2. 设置 Samba 用户密码

使用提供的设置脚本：

```bash
sudo ./scripts/setup/setup-samba.sh
```

或手动设置：

```bash
sudo smbpasswd -a sheep
```

## 📁 共享目录

系统会自动创建以下共享目录：

### 公开共享 (`public`)
- **路径**: `/mnt/Shares/Public`
- **访问权限**: 无需密码，任何人可读写
- **用途**: 共享文件、临时传输
- **网络路径**: `\\niri-dot\public`

### 私有共享 (`private`)
- **路径**: `/mnt/Shares/Private`
- **访问权限**: 需要用户名和密码
- **用途**: 个人文件、敏感数据
- **网络路径**: `\\niri-dot\private`

### TimeMachine 共享 (`TimeMachine`)
- **路径**: `/mnt/Shares/TimeMachine`
- **访问权限**: 需要 macOS 用户认证
- **用途**: Apple TimeMachine 备份
- **网络路径**: `\\niri-dot\TimeMachine`

## 🔧 配置详情

### 网络设置
- **工作组**: `WORKGROUP`
- **服务器名称**: `niri-dot`
- **协议版本**: SMB2/SMB3
- **防火墙**: 自动开放相关端口

### 开放的端口
- **TCP**: 139, 445, 5357-5359
- **UDP**: 137, 138, 3702-3703

### 安全设置
- 允许的访问范围: `192.168.`, `10.`, `127.0.0.1`
- 其他 IP 地址被拒绝访问
- 密码加密: 启用

## 📱 客户端连接

### Windows

1. 打开文件资源管理器
2. 在地址栏输入: `\\niri-dot\public`
3. 或者使用 IP 地址: `\\192.168.x.x\public`
4. 输入用户名和密码（私有共享需要）

### macOS

1. 打开访达 (Finder)
2. 按 `Cmd + K` 或选择"前往" → "连接服务器"
3. 输入: `smb://niri-dot/public`
4. 连接并认证

### Linux

使用 `smbclient` 或文件管理器：
```bash
# 测试连接
smbclient -L //niri-dot

# 连接公开共享
smbclient //niri-dot/public

# 连接私有共享
smbclient //niri-dot/private -U sheep
```

## 🛠️ 管理和维护

### 用户管理
```bash
# 添加新用户
sudo smbpasswd -a username

# 修改用户密码
sudo smbpasswd username

# 删除用户
sudo smbpasswd -x username

# 列出所有 Samba 用户
sudo pdbedit -L
```

### 服务管理
```bash
# 检查服务状态
systemctl status smb nmb wsdd

# 重启服务
sudo systemctl restart smb nmb wsdd

# 查看日志
journalctl -u smb -f
```

### 配置验证
```bash
# 测试 Samba 配置
sudo testparm

# 测试共享列表
smbclient -L //localhost

# 测试网络访问
smbclient //localhost/public
```

## 🔒 安全建议

1. **定期更新密码**: 建议定期更改 Samba 用户密码
2. **网络隔离**: 确保只允许受信任的网络访问
3. **权限控制**: 为敏感目录设置适当的文件权限
4. **备份重要数据**: 定期备份共享目录中的重要文件
5. **监控访问**: 定期检查访问日志，发现异常访问

## 🐛 故障排除

### 无法访问共享
1. 检查服务状态: `systemctl status smb nmb wsdd`
2. 验证防火墙设置
3. 检查网络连接
4. 确认用户密码正确

### 权限问题
1. 检查目录权限: `ls -la /mnt/Shares/`
2. 验证用户组成员关系
3. 检查 SELinux 状态（如果启用）

### 性能问题
1. 调整 `max protocol` 设置
2. 启用 `use sendfile` 选项
3. 检查网络带宽
4. 考虑使用 SSD 存储共享文件

## 📚 参考资源

- [Samba 官方文档](https://www.samba.org/samba/docs/)
- [NixOS Samba 配置](https://nixos.wiki/wiki/Samba)
- [Samba 安全指南](https://www.samba.org/samba/docs/current/man-html/smb.conf.5.html)

## 🆘 获取帮助

如果遇到问题，可以：

1. 查看系统日志: `journalctl -u smb`
2. 运行诊断脚本: `./scripts/testing/ci-check.sh`
3. 检查配置文件: `cat /etc/samba/smb.conf`
4. 在项目仓库提交 issue