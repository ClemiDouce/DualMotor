extends Node

var part_list = ["FLAG", "CACTUS", "PISTON", "SPIKE", "KEY", "PANNEL", "LEVER", "MUSHROOM", "BOMB"]

var clean_motor := {
	"top1": null,
	"top2": null,
	"down": null,
	"left": null,
	"right": null
}

func remap_range(value, InputA, InputB, OutputA, OutputB):
	return(value - InputA) / (InputB - InputA) * (OutputB - OutputA) + OutputA
