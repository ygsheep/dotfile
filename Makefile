# Niri-Dot Makefile
# 提供常用的项目管理和维护命令

# 主机配置 (可覆盖: make build HOST=laptop)
HOST ?= thinkbook

.PHONY: help check format build clean test validate docs install-deps build-thinkbook switch-thinkbook build-desktop switch-desktop

# 默认目标
help:
	@echo "Niri-Dot 项目管理命令:"
	@echo ""
	@echo "变量:"
	@echo "  HOST=$(HOST)  - 目标主机 (desktop/laptop/thinkbook)"
	@echo ""
	@echo "检查和验证:"
	@echo "  check      - 运行所有检查 (语法、格式、构建)"
	@echo "  validate   - 验证配置完整性"
	@echo "  test       - 运行测试套件"
	@echo ""
	@echo "构建和部署:"
	@echo "  build      - 构建 NixOS 配置 (当前主机: $(HOST))"
	@echo "  switch     - 应用配置 (需要 root)"
	@echo "  test-build - 测试构建但不应用"
	@echo ""
	@echo "快捷构建:"
	@echo "  build-thinkbook  - 构建 thinkbook 配置"
	@echo "  switch-thinkbook - 应用 thinkbook 配置"
	@echo "  build-desktop    - 构建 desktop 配置"
	@echo "  switch-desktop   - 应用 desktop 配置"
	@echo ""
	@echo "代码质量:"
	@echo "  format     - 格式化所有 Nix 文件"
	@echo "  clean      - 清理构建结果"
	@echo ""
	@echo "文档和工具:"
	@echo "  docs       - 打开文档中心"
	@echo "  update     - 更新 flake 锁文件"

# 检查和验证
check:
	@echo "🔍 运行完整检查..."
	@./scripts/testing/ci-check.sh

validate:
	@echo "✅ 验证配置完整性..."
	@./scripts/testing/validate-config.sh

test: check validate
	@echo "🧪 所有测试完成"

# 构建和部署
build:
	@echo "🏗️  构建 NixOS 配置 ($(HOST))..."
	nix build .#nixosConfigurations.$(HOST).config.system.build.toplevel

test-build:
	@echo "🧪 测试构建..."
	nix flake show --all-systems

switch: check
	@echo "🔄 应用配置 ($(HOST), 需要 root 权限)..."
	sudo nixos-rebuild switch --flake .#$(HOST)

# 代码质量
format:
	@echo "📝 格式化 Nix 文件..."
	@if command -v alejandra >/dev/null 2>&1; then \
		alejandra .; \
	else \
		echo "⚠️  alejandra 未安装，使用 nix run:"; \
		nix run nixpkgs#alejandra -- .; \
	fi

clean:
	@echo "🧹 清理构建结果..."
	nix flake clean
	rm -rf result

# 文档和工具
docs:
	@echo "📖 打开文档中心..."
	@if command -v xdg-open >/dev/null 2>&1; then \
		xdg-open ./docs/README.md; \
	elif command -v open >/dev/null 2>&1; then \
		open ./docs/README.md; \
	else \
		echo "请手动打开 ./docs/README.md"; \
	fi

update:
	@echo "⬆️  更新依赖..."
	nix flake update

install-deps:
	@echo "📦 安装开发依赖..."
	nix profile install nixpkgs#alejandra nixpkgs#nix-linter

# 快捷命令
quick-check:
	@echo "⚡ 快速检查..."
	@nix flake check --no-build

status:
	@echo "📊 项目状态:"
	@echo "配置文件: $$(find . -name '*.nix' | wc -l)"
	@echo "Shell 脚本: $$(find . -name '*.sh' | wc -l)"
	@echo "文档文件: $$(find . -name '*.md' | wc -l)"
	@echo "最后提交: $$(git log -1 --format='%h %s' 2>/dev/null || echo 'N/A')"

# 开发环境
dev-shell:
	@echo "🐚 进入开发环境..."
	nix develop

# 维护脚本
maintenance:
	@echo "🛠️  运行维护脚本..."
	@./scripts/maintenance/random-wallpaper.sh || true

install-wallpaper:
	@echo "🖼️  设置壁纸脚本..."
	@chmod +x ./scripts/maintenance/random-wallpaper.sh
	@echo "✅ 壁纸脚本已设置可执行权限"

# 项目信息
info:
	@echo "📋 Niri-Dot 项目信息:"
	@echo "版本: 2.0.0"
	@echo "发布日期: 2025-01-08"
	@echo "NixOS: 25.05"
	@echo "主页: https://github.com/ygsheep/dotfile"
	@echo "文档: ./docs/README.md"

# 主机特定快捷命令
build-thinkbook:
	@$(MAKE) build HOST=thinkbook

switch-thinkbook:
	@$(MAKE) switch HOST=thinkbook

build-desktop:
	@$(MAKE) build HOST=desktop

switch-desktop:
	@$(MAKE) switch HOST=desktop