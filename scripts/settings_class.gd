class_name Settings extends Resource

enum OSTypes {
	X11,
	Windows,
	Mac
}

export var first_run = false
export(OSTypes) var operating_system = OSTypes.X11
export var bound_directory = "/home/jelly/Documents/Bound/bound.x86_64"
export var darkTheme = false
export var Fancy = false
