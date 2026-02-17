# NixOS Makefile - 简化版命令

HOST ?= thinkbook

.PHONY: help s b si bi switch build check format clean update

# 默认目标显示帮助
help:
	@echo "NixOS 常用命令:"
	@echo ""
	@echo "  make s       - 应用配置 (默认: $(HOST))"
	@echo "  make b       - 构建配置 (默认: $(HOST))"
	@echo "  make si      - 交互式选择主机并应用"
	@echo "  make bi      - 交互式选择主机并构建"
	@echo "  make switch  - 完整 switch (可: HOST=desktop make switch)"
	@echo "  make build   - 完整 build (可: HOST=desktop make build)"
	@echo ""
	@echo "  make check   - 运行检查"
	@echo "  make format  - 格式化"
	@echo "  make clean   - 清理"
	@echo "  make update  - 更新"

# ========== 快捷命令 ==========

# s = switch 快捷版
s: switch

# b = build 快捷版
b: build

# 交互式 switch
si:
	@echo "选择主机:"
	@echo "  1) desktop"
	@echo "  2) thinkbook"
	@read -p "请输入选项 [1-2]: " choice; \
	case $$choice in \
		1) $(MAKE) switch HOST=desktop ;; \
		2) $(MAKE) switch HOST=thinkbook ;; \
		*) echo "无效选项" ;; \
	esac

# 交互式 build
bi:
	@echo "选择主机:"
	@echo "  1) desktop"
	@echo "  2) thinkbook"
	@read -p "请输入选项 [1-2]: " choice; \
	case $$choice in \
		1) $(MAKE) build HOST=desktop ;; \
		2) $(MAKE) build HOST=thinkbook ;; \
		*) echo "无效选项" ;; \
	esac

# ========== 完整命令 ==========

switch: check
	@echo "🔄 应用配置 ($(HOST))..."
	sudo nixos-rebuild switch --flake .#$(HOST)

build:
	@echo "🏗️  构建 ($(HOST))..."
	nix build .#nixosConfigurations.$(HOST).config.system.build.toplevel

check:
	@./scripts/testing/ci-check.sh

format:
	@echo "📝 格式化..."
	@nix run nixpkgs#alejandra -- .

clean:
	@echo "🧹 清理..."
	nix flake clean
	rm -rf result

update:
	@echo "⬆️  更新..."
	nix flake update

info:
	@echo "NixOS v2.0.0 | hosts: desktop, thinkbook"
