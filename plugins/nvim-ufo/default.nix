{ name, project, vimUtils, ... }:

vimUtils.buildVimPlugin {
  pname = name;
  version = project.inputs.${name}.src.revision;

  src = project.inputs.${name}.result;

  # Fails, likely due to needing the promise-async Lua library
  # which is only included in the Neovim config, not
  # in this plugin.
  doCheck = false;
}
