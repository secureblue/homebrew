# shellcheck shell=bash disable=SC1090

# SPDX-FileCopyrightText: Copyright 2025 Universal Blue
# SPDX-FileCopyrightText: Copyright 2025 The BlueBuild Authors
# SPDX-FileCopyrightText: Copyright 2026 Daniel Hast
#
# SPDX-License-Identifier: Apache-2.0

original_comp_load_definition="$(declare -f _comp_load)"
renamed_comp_load_definition="$(printf '%s\n' "${original_comp_load_definition}" | sed '1s/_comp_load/bash_completion_load/')"
eval "${renamed_comp_load_definition}"
unset original_comp_load_definition renamed_comp_load_definition

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
      bash_completion_load "$@"
    fi
  else
    local path_without_brew=":${PATH}"
    path_without_brew="${path_without_brew//":${brew_bin_folder}"/}"
    path_without_brew="${path_without_brew//":${brew_sbin_folder}"/}"
    local PATH="${path_without_brew#:}"
    bash_completion_load "$@"
  fi
}
