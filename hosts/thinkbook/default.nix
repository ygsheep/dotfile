{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [./hardware-configuration.nix];

  boot = {
    # 加载内核模块 - AMD CPU 配置
    kernelModules = ["amdgpu" "kvm-amd" "i2c-dev" "efivarfs" "thinkpad_acpi"];
    kernelPackages = lib.mkForce pkgs.linuxPackages_cachyos-lts;
    kernelParams = [
      "amd_pstate=active" # 启用 AMD P-state CPU 缩放驱动
      "amd_iommu=force" # 强制启用 AMD IOMMU 以获得更好的 DMA 保护
      "mitigations=off" # 禁用 CPU 安全缓解措施（提高性能，降低安全性）
      "ideapad_laptop" # 允许联想 IdeaPad 的动态散热控制
      "nvme_core.default_ps_max_latency_us=0" # 设置 NVMe 电源状态延迟为最小值（最高性能）

      "randomize_kstack_offset=on" # 在每次系统调用时随机化内核栈偏移（缓解某些漏洞利用）
      "vsyscall=none" # 禁用 vsyscall（移除旧的系统调用接口，提高安全性）
      "slab_nomerge" # 禁用合并类似的 SLAB 缓存（加强对某些堆攻击的防护）
      "module.sig_enforce=1" # 只允许加载具有有效签名的内核模块（防止未签名模块）
      "lockdown=confidentiality" # 在机密模式下启用内核锁定（限制对内核的访问，即使是 root）
      "page_poison=1" # 用毒值填充释放的内存页（有助于检测释放后重用漏洞）
      "page_alloc.shuffle=1" # 随机化页面分配器顺序（缓解某些内存损坏攻击）
      "sysrq_always_enabled=0" # 完全禁用魔法 SysRq 键（防止低级系统命令）
      "rootflags=noatime" # 使用 noatime 挂载根文件系统（提高性能，禁用文件访问时间更新）
      "lsm=landlock,lockdown,yama,integrity,apparmor,bpf,tomoyo,selinux" # 启用并排序 Linux 安全模块（堆叠 LSM 提高安全性）
      "fbcon=nodefer" # 不延迟内核消息到帧缓冲控制台（立即显示消息）

      # 用于 HSI 合规性的额外安全加固（已验证）
      "init_on_alloc=1" # 初始化分配的内存
      "init_on_free=1" # 初始化释放的内存
    ];
    kernel.sysctl = {
      "vm.swappiness" = 10; # 降低交换倾向（默认为 60）
      "vm.vfs_cache_pressure" = 50; # 降低缓存压力（默认为 100）
      "vm.dirty_ratio" = 10; # 降低写回前的最大脏内存百分比（默认为 20）
      "vm.dirty_background_ratio" = 5; # 降低开始后台写回的脏内存百分比（默认为 10）

      "kernel.nmi_watchdog" = 0; # 禁用 NMI 看门狗（略微提高性能）

      # 网络性能优化
      "net.core.netdev_budget" = 600;
      "net.core.netdev_max_backlog" = 16384;
      "net.ipv4.tcp_no_metrics_save" = 1;
      "net.ipv4.tcp_moderate_rcvbuf" = 1;

      "kernel.sysrq" = 0; # 禁用魔法 SysRq 键（防止低级系统命令）
      "kernel.kptr_restrict" = 2; # 对非特权用户隐藏内核指针（安全性）
      "kernel.ftrace_enabled" = false; # 禁用内核函数跟踪（安全性，禁用调试）
      "kernel.dmesg_restrict" = 1; # 限制非 root 用户访问 dmesg（安全性）
      "fs.protected_fifos" = 2; # 完全限制写入不属于写入者的 FIFO（安全性）
      "fs.protected_regular" = 2; # 完全限制写入不属于写入者的常规文件（安全性）
      "fs.suid_dumpable" = 0; # 禁用 setuid 程序的核心转储（安全性）
      "net.core.bpf_jit_harden" = 2; # 为所有用户加固 BPF JIT 编译器

      # 额外安全加固
      "kernel.core_uses_pid" = 1; # 将 PID 附加到核心文件名
      "kernel.randomize_va_space" = 2; # 完整 ASLR
      "vm.mmap_rnd_bits" = 32; # 增加 mmap 的 ASLR 熵
      "vm.mmap_rnd_compat_bits" = 16; # 增加 compat mmap 的 ASLR 熵
      "dev.tty.ldisc_autoload" = 0; # 禁用 TTY 线路规程自动加载
      "vm.unprivileged_userfaultfd" = 0; # 禁用非特权 userfaultfd
    };

    blacklistedKernelModules = [
      # 晦涩的网络协议
      "af_802154" # IEEE 802.15.4
      "appletalk" # Appletalk
      "atm" # ATM
      "ax25" # 业余 X.25
      "decnet" # DECnet
      "econet" # Econet
      "ipx" # 网间分组交换
      "n-hdlc" # 高级数据链路控制
      "netrom" # NetRom
      "p8022" # IEEE 802.3
      "p8023" # Novell raw IEEE 802.3
      "psnap" # 子网络访问协议
      "rds" # 可靠数据报服务
      "rose" # ROSE
      "tipc" # 透明进程间通信
      "x25" # X.25

      # 旧的或罕见的或审计不足的文件系统
      "adfs" # Active Directory 联合服务
      "affs" # Amiga 快速文件系统
      "befs" # Be 文件系统
      "bfs" # BFS，由 SCO UnixWare OS 用于 /stand 切片
      "cramfs" # 压缩 ROM/RAM 文件系统
      "efs" # 扩展文件系统
      "erofs" # 增强型只读文件系统
      "exofs" # 扩展对象文件系统
      "f2fs" # 友好闪存文件系统
      "freevxfs" # Veritas 文件系统驱动程序
      "gfs2" # 全局文件系统 2
      "hfs" # 分层文件系统（Macintosh）
      "hfsplus" # 同上，但具有扩展属性
      "hpfs" # 高性能文件系统（由 OS/2 使用）
      "jffs2" # 日志闪存文件系统（v2）
      "jfs" # 日志文件系统 - 仅对 VMWare 会话有用
      "ksmbd" # SMB3 内核服务器
      "minix" # minix fs - 由 minix OS 使用
      "nilfs2" # 日志结构文件系统的新实现
      "omfs" # 优化的 MPEG 文件系统
      "qnx4" # 由 QNX4 OS 使用的基于范围的文件系统
      "qnx6" # 由 QNX6 OS 使用的基于范围的文件系统
      "squashfs" # 压缩只读文件系统（由实时 CD 使用）
      "sysv" # 实现 Xenix FS、SystemV/386 FS 和 Coherent FS 的所有功能
      "udf" # https://docs.kernel.org/5.15/filesystems/udf.html
      "vivid" # 虚拟视频测试驱动程序（不必要）

      # 禁用 Thunderbolt 和 FireWire 以防止 DMA 攻击
      "firewire-core"
      "thunderbolt"
    ];
  };

  networking.hostName = "thinkbook";

  security.tpm2.enable = true;

  # HSI 合规性的额外安全加固
  security = {
    forcePageTableIsolation = true;
    protectKernelImage = true;
    apparmor = {
      enable = true;
      killUnconfinedConfinables = true;
    };
  };

  services = {
    # 用于 SSD/NVMe
    fstrim.enable = true;
    scx.enable = true;
    scx.scheduler = "scx_rusty";

    # 笔记本电脑电源管理
    upower.enable = true;
    thermald.enable = true;
    auto-cpufreq.enable = true;
    # 禁用 power-profiles-daemon（与 auto-cpufreq 冲突）
    power-profiles-daemon.enable = lib.mkForce false;
  };

  hardware = {
    enableRedistributableFirmware = true;
    cpu.amd.updateMicrocode = true;
  };

  # 额外的 systemd 加固
  systemd = {
    coredump.extraConfig = ''
      Storage=none
      ProcessSizeMax=0
    '';
  };

  environment.systemPackages = [pkgs.cryptsetup pkgs.swww];
}
