#!/usr/bin/env bash
set -Eeuo pipefail

REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"

PACKAGES=(
  hyprland quickshell waybar kitty rofi
  hyprlock hypridle awww matugen
  wl-clipboard cliphist grim slurp brightnessctl playerctl cava jq
  networkmanager network-manager-applet polkit-kde-agent
  pipewire pipewire-pulse wireplumber pavucontrol
  xdg-desktop-portal-hyprland xdg-desktop-portal-gtk
  bluez bluez-utils git libnotify starship zsh
  ttf-jetbrains-mono-nerd
)

ITEMS=(
  hypr kitty quickshell rofi starship.toml waybar
  personal-theme matugen
)

[[ -f /etc/arch-release ]] || {
  echo "Ошибка: требуется Arch Linux."
  exit 1
}

(( EUID != 0 )) || {
  echo "Запусти от обычного пользователя, не через sudo."
  exit 1
}

command -v sudo >/dev/null 2>&1 || {
  echo "Ошибка: sudo не найден."
  exit 1
}

echo "=== Проверка исходных файлов ==="
for item in "${ITEMS[@]}"; do
  [[ -e "$REPO_DIR/.config/$item" ]] || {
    echo "Ошибка: отсутствует .config/$item"
    exit 1
  }
  echo "[OK] $item"
done

[[ -f "$REPO_DIR/.config/hypr/hyprland.lua" ]] || {
  echo "Ошибка: не найден hyprland.lua."
  exit 1
}

[[ -x "$REPO_DIR/.config/personal-theme/bin/theme.py" ]] || {
  echo "Ошибка: theme.py не исполняемый."
  exit 1
}

echo
echo "=== Пакеты ==="
printf '  %s\n' "${PACKAGES[@]}"
read -r -p "Установить/обновить пакеты через pacman? [y/N] " answer
[[ "$answer" =~ ^[Yy]$ ]] || {
  echo "Отменено."
  exit 0
}

sudo pacman -Syu --needed "${PACKAGES[@]}"

BACKUP_ROOT="$HOME/.local/share/arch-hyprland-dotfiles-backups"
mkdir -p "$BACKUP_ROOT" "$CONFIG_DIR"
BACKUP_DIR="$(mktemp -d "$BACKUP_ROOT/$(date +%Y%m%d-%H%M%S)-XXXXXX")"

declare -A HAD_TARGET=()

echo
echo "=== Создание резервной копии ==="
for item in "${ITEMS[@]}"; do
  target="$CONFIG_DIR/$item"

  if [[ -e "$target" || -L "$target" ]]; then
    cp -a -- "$target" "$BACKUP_DIR/$item"
    HAD_TARGET["$item"]=1
    echo "[BACKUP] $item"
  else
    HAD_TARGET["$item"]=0
    echo "[NEW] $item"
  fi
done

echo
echo "Резервная копия: $BACKUP_DIR"
echo "Будут заменены перечисленные конфиги."
read -r -p "Продолжить копирование? [y/N] " answer
[[ "$answer" =~ ^[Yy]$ ]] || {
  echo "Копирование отменено. Резервная копия сохранена."
  exit 0
}

rollback() {
  local item target
  trap - ERR

  echo
  echo "ОШИБКА: копирование не завершилось. Восстанавливаю исходные конфиги..."

  local rollback_failed=0

  for item in "${ITEMS[@]}"; do
    target="$CONFIG_DIR/$item"

    if ! rm -rf -- "$target"; then
      echo "[ОШИБКА] Не удалось очистить $target"
      rollback_failed=1
      continue
    fi

    if [[ "${HAD_TARGET[$item]:-0}" == 1 ]]; then
      if ! cp -a -- "$BACKUP_DIR/$item" "$target"; then
        echo "[КРИТИЧЕСКАЯ ОШИБКА] Не удалось восстановить $item"
        rollback_failed=1
      else
        echo "[RESTORED] $item"
      fi
    fi
  done

  if (( rollback_failed )); then
    echo "[ВНИМАНИЕ] Откат завершён не полностью."
  fi

  echo "Проверь резервную копию: $BACKUP_DIR"
  exit 1
}

trap rollback ERR

echo
echo "=== Копирование конфигов ==="
for item in "${ITEMS[@]}"; do
  source="$REPO_DIR/.config/$item"
  target="$CONFIG_DIR/$item"

  rm -rf -- "$target"
  cp -a -- "$source" "$target"
  echo "[OK] $item"
done

trap - ERR

mkdir -p "$HOME/Pictures/Wallpapers"

echo
echo "=== Проверка команд ==="
for cmd in hyprland quickshell waybar kitty rofi hyprlock hypridle \
           awww matugen grim slurp wl-copy cliphist playerctl \
           brightnessctl cava jq nm-applet python3; do
  if command -v "$cmd" >/dev/null 2>&1; then
    printf '[OK] %s\n' "$cmd"
  else
    printf '[НЕТ] %s\n' "$cmd"
  fi
done

echo
echo "Конфиги скопированы."
echo "Генерация темы и перезапуск Hyprland не выполнялись."
echo "Обои не копировались."
echo "Резервная копия: $BACKUP_DIR"
