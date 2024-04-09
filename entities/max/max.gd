extends Node2D

##
# Max
# |- _process() enqueue / dequeue
# |- Poseable
#    |- set_state
# |- Walkable
#    |- var path_queue: PathQueue
#    |- enqueue_path
# |- Controllable
#    |- _input
#    |- signal enqueue_input(o: Orientation)

const _libgeo = preload('res://lib/geo.gd')
const _libpose = preload('res://lib/pose.gd')
const _libpathqueue = preload('res://lib/pathqueue.gd')

const _GRID_SIZE = 16
const _GRID_CENTER_OFFSET = Vector2(_GRID_SIZE, _GRID_SIZE) / 2
const _SPEED = 3.0
const _POLL_RATE_LIMIT = 15.0

var _tween: Tween
var _path_queue: _libpathqueue.PathQueue = _libpathqueue.PathQueue.new(1)
var _delta_accum: float = 0.0
var _gp: _libgeo.GeoPosition = _libgeo.GeoPosition.new(_GRID_CENTER_OFFSET, _GRID_SIZE)

@onready var _p = $Poseable
@onready var _c = $Controllable
@onready var _w = $Walkable


func _ready():
	_c.action_north.connect(func(): _w.path_queue.enqueue(_libgeo.Orientation.N))
	_c.action_south.connect(func(): _w.path_queue.enqueue(_libgeo.Orientation.S))
	_c.action_east.connect(func(): _w.path_queue.enqueue(_libgeo.Orientation.E))
	_c.action_west.connect(func(): _w.path_queue.enqueue(_libgeo.Orientation.W))
