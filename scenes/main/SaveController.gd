extends Control

var save_path = "res://save data/save.save"
var player
var camera

func save():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
