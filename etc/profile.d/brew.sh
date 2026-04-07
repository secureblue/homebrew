#!/bin/sh

# SPDX-FileCopyrightText: Copyright 2025 Universal Blue
# SPDX-FileCopyrightText: Copyright 2025 The BlueBuild Authors
# SPDX-FileCopyrightText: Copyright 2026 Daniel Hast
#
# SPDX-License-Identifier: Apache-2.0

if [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
  case "$(/usr/bin/id -nu)" in
    root) # Never put brew commands in PATH for root user
      ;;
    linuxbrew) # Always put brew commands in PATH for linuxbrew user
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
      ;;
    *) # Put brew commands in PATH for other users only in interactive sessions
      case "$-" in
        *i*)
          eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
          ;;
      esac
      ;;
  esac
fi
