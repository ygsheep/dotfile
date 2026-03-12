# Warp Terminal 配置
# 注意：更新警告无法完全禁用，这是 Warp 的已知问题
# 参见：https://github.com/warpdotdev/Warp/issues/4526
{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [warp-terminal];

  # Warp 使用传统 shell 路径（已在 system/core/shell-compat.nix 中配置）
  # 如需禁用更新检查的网络访问，可使用以下方式：
  #
  # systemd.user.services.warp-update-block = {
  #   unitConfig.Description = "Block Warp update checks";
  #   serviceConfig = {
  #     ExecStart = "${pkgs.iptables}/bin/iptables -A OUTPUT -p tcp --dport 443 -m owner --uid-owner sheep -j REJECT";
  #     ExecStop = "${pkgs.iptables}/bin/iptables -D OUTPUT -p tcp --dport 443 -m owner --uid-owner sheep -j REJECT";
  #     RemainAfterExit = true;
  #   };
  #   wantedBy = ["default.target"];
  #   partOf = ["graphical-session.target"];
  # };
}
