extends Node3D
var player_limit = 1
var player_count = 0

var player = preload("res://src/scenes/tofu_proto.tscn")
var camera = preload("res://src/scenes/camera_3d.tscn")

var instance = player.instantiate()
var current_node_name = "Tofu_Final"
var current_player_name = "null"
var camera_tween = "blank"
var camera_interpolation = false
@export var player_array = []

@export var camera_scroll = true 

@onready var camera_node = get_node("Camera_Node")





func _on_music_finished():
	$Music.play()

func _ready():
	pass

func _physics_process(delta):
	spawn_players(2)
	camera_movement()


func spawn_players(_amount):
		player_limit = _amount
		while player_count < player_limit:
			instance = player.instantiate()
			add_child(instance, true)
			player_count += 1
			#print(player_count)
			
			if player_count == 1:
				#get_node("Tofu_Final").add_child(camera.instantiate()) for other camera
				
				get_node("Tofu_Final").player = player_count
				get_node("Tofu_Final").is_ready = true
				
				player_array.push_front(get_node("Tofu_Final")) #ADDS P1 TO ARRAY
				#print(get_node("Tofu_Final").player)
			else:
				current_player_name = (str(current_node_name, player_count))
				get_node(current_player_name).player = player_count
				get_node(current_player_name).is_ready = true
				
				player_array.push_back(get_node(current_player_name)) #ADDS P2 TO ARRAY
				#print(get_node(current_player_name).player)
				
		



func camera_movement():
	#OBJECT VARS
	camera_tween = get_tree().create_tween()
	
	
	
	if camera_scroll == true:
		if player_count == 1:
			camera_node.position.x = get_node("Tofu_Final").position.x
			camera_node.position.y = get_node("Tofu_Final").position.y
			#camera_node.position.z = (get_node("Tofu_Final").position.y / 8 ) + 7 #whack
			camera_node.position.z = 7
		
		if player_count == 2:
			camera_node.position.x = ((player_array[0].position.x + player_array[1].position.x) / player_count ) # AVERAGE FROM THE TWO X VALUES
			camera_node.position.y = ((player_array[0].position.y + player_array[1].position.y) / player_count ) # AVERAGE FROM THE TWO Y VALUES
			camera_node.position.z = (abs((player_array[0].position.x - player_array[1].position.x) + ((abs(player_array[0].position.y - player_array[1].position.y) / 2)) / player_count)) # DISTANCE FROM VALUES, RATHER THAN AVERAGE
			#camera_node.position.z = (abs((player_array[0].position.x - player_array[1].position.x) + ((abs(player_array[0].position.y + player_array[1].position.y) / 2) * -2) / player_count)) # DISTANCE FROM VALUES, RATHER THAN AVERAGE
			
			camera_node.position.x = camera_node.position.x / 1.07
			camera_node.position.y = camera_node.position.y / 1.2
			camera_node.position.z = camera_node.position.z / 5 + 5
			
			
		if player_count == 3:
			camera_node.position.x = ((player_array[0].position.x + player_array[1].position.x + player_array[2].position.x) / player_count ) # AVERAGE FROM THE TWO X VALUES
			camera_node.position.y = ((player_array[0].position.y + player_array[1].position.y + player_array[2].position.y) / player_count ) # AVERAGE FROM THE TWO Y VALUES
			camera_node.position.z = (abs((player_array[0].position.x - player_array[1].position.x - player_array[2].position.x) + ((abs(player_array[0].position.y + player_array[1].position.y + player_array[2].position.y) / 3 ) * -2) / player_count)) # DISTANCE FROM VALUES, RATHER THAN AVERAGE
		
		#camera_node.position.x = get_node()
		
			camera_node.position.x = camera_node.position.x / 1.07
			camera_node.position.y = camera_node.position.y / 1.2
			camera_node.position.z = camera_node.position.z / 5 + 10
		
		if player_count == 4:
			
			camera_node.position.x = ((player_array[0].position.x + player_array[1].position.x + player_array[2].position.x + player_array[3].position.x) / 4 ) # AVERAGE FROM THE TWO X VALUES
			camera_node.position.y = ((player_array[0].position.y + player_array[1].position.y + player_array[2].position.y + player_array[3].position.y) / 4 ) # AVERAGE FROM THE TWO Y VALUES
			camera_node.position.z = (abs(((player_array[0].position.x - player_array[1].position.x) + (player_array[2].position.x - player_array[3].position.x) / 2 ) + ((abs(player_array[0].position.y + player_array[1].position.y + player_array[2].position.y + player_array[3].position.y) / 4 ) * -2) / 4) / 4 + 7) # DISTANCE FROM VALUES, RATHER THAN AVERAGE
			
		if camera_node.position.z < 0:
				camera_node.position.z = 0
	else: 
		camera_node.position = Vector3(0, 5.357, 18.044) # when this property is enabled, the Camera remains stationary
		
	if camera_interpolation == true:
			camera_tween.tween_property(camera_node, "position",camera_node.position, 0.35)#camera_node.position.y), 0.5) # INTERPOLATES THE CAMERA
		
	
func _process(delta):
	var fps = Engine.get_frames_per_second()
	#var lerp_interval = 
