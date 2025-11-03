{ name, project, vimUtils, ... }:

vimUtils.buildVimPlugin {
	pname = name;
	version = "";

	src = project.inputs.${name}.result;

	nvimSkipModules = [
		# Currently fails trying to call `.colors`.
		"evergarden.extras"
	];
}
