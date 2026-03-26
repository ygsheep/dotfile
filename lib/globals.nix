{self}: {
  user = "sheep";
  homeDir = "/home/sheep";
  projectDir = toString self;
  assetsDir = "${toString self}/assets";
  version = "2.0.0";
  releaseDate = "2025-01-08";

  # 代理配置
  # proxy = {
  #   http = "http://127.0.0.1:20171";
  #   https = "http://127.0.0.1:20172";
  #   socks = "socks5://127.0.0.1:20170";
  #   noProxy = "localhost,192.168.8.8,::1,.local,.lan,192.168.*.*,192.168.0.0/16,10.0.0.0/8,172.16.0.0/12";
  # };
  proxy = {
    http = "";
    https = "";
    socks = "";
    noProxy = "*";
  };
}
