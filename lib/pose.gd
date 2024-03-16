extends Object

const _libgeo = preload("res://lib/geo.gd")

enum Pose { IDLE, WALK }

const POSE_STRING = {
	Pose.IDLE: "idle",
	Pose.WALK: "walk",
}

const POSE_ORIENTATION_STRING = {
	_libgeo.Orientation.N: "north",
	_libgeo.Orientation.S: "south",
	_libgeo.Orientation.E: "west",
	_libgeo.Orientation.W: "west",
}
