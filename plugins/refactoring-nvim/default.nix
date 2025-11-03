{ name, project, vimUtils, ... }:

vimUtils.buildVimPlugin {
  pname = name;
  version = project.inputs.${name}.src.revision;

  src = project.inputs.${name}.result;

  doCheck = false;
}
