# shellcheck shell=bash disable=SC1090

# SPDX-FileCopyrightText: Copyright 2025 Universal Blue
# SPDX-FileCopyrightText: Copyright 2025 The BlueBuild Authors
# SPDX-FileCopyrightText: Copyright 2026 Daniel Hast
#
# SPDX-License-Identifier: Apache-2.0

eval "$(declare -f _comp_load | sed '1s/_comp_load/_bash_completion_original_comp_load/')"

_comp_load() {
  local command_name="${*: -1}"

  local command_path
  command_path="$(type -P "${command_name}")"
  local command_folder
  command_folder="$(dirname "${command_path}")"
  local brew_bin_folder="/home/linuxbrew/.linuxbrew/bin"
  local brew_sbin_folder="/home/linuxbrew/.linuxbrew/sbin"
  if [[ "${command_folder}" == "${brew_bin_folder}" ]] || [[ "${command_folder}" == "${brew_sbin_folder}" ]]; then
    local command_file_name
    command_file_name="$(basename "${command_path}")"
    local brew_completions_folder="/home/linuxbrew/.linuxbrew/etc/bash_completion.d"
    local completion_file="${brew_completions_folder}/${command_file_name}"
    if [[ -r "${completion_file}" ]]; then
      . "${completion_file}"
      return 0
    else
      _bash_completion_original_comp_load "$@"
    fi
  else
    local brew_bin_entry=":${brew_bin_folder}:"
    local brew_sbin_entry=":${brew_sbin_folder}:"
    local path_without_brew=":${PATH}:"
    while [[ "${path_without_brew}" == *"${brew_bin_entry}"* ]] || [[ "${path_without_brew}" == *"${brew_sbin_entry}"* ]]; do
      path_without_brew="${path_without_brew//"${brew_bin_entry}"/:}"
      path_without_brew="${path_without_brew//"${brew_sbin_entry}"/:}"
    done
    path_without_brew="${path_without_brew%:}"
    local PATH="${path_without_brew#:}"
    _bash_completion_original_comp_load "$@"
  fi
}
