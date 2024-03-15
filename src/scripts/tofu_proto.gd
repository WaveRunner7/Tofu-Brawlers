extends CharacterBody3D

var gravity = 3

var state = "netrual"
var default_jumps = 3 # Amount Of Extra Jumps
var default_jump_pow = 40
var jump_pow = default_jump_pow
var jumps = default_jumps

var player = 0
var player_input = player - 1
var land = false
var land_count = 0
@export var is_ready = false
var launched = false
var jump_request = false
@export var launch_force = 0.



var player_hex = ["ff4d3b", "3088fd", "ff671f", "c272ff"]
var started = false #30
var start_positions = [Vector3(-20,0,0),Vector3(20,0,0), Vector3(-2,0,0), Vector3(2,0,0)] #UPON SPAWNING THESE ARE THE PLAYERS POSITIONS
var player_mats = [preload("res://src/player_mats/player1.tres"), preload("res://src/player_mats/player2.tres"), preload("res://src/player_mats/player3.tres"), preload("res://src/player_mats/player4.tres")]

var is_actually_visible = true




# THE WAY CONTROLS ARE HANDELD IS THE PLAYER IS ASSIGNED TO A NUMBER, THIS NUMBER CONTROLS THE ARRAYS OF THE DIFFERENT CONTROL STRINGS TO GET INPUT
# Controls






func _physics_process(delta):
	if is_ready == false:
		hide()
		#player is hidden until made availible by the is_ready function
	if is_ready == true:
		fix_player_number()
		
		go_pos()
		
		
		move_physics()
		
		visibility()
		

func move_physics():
	if position.z != 0: #glues 3D z axis Position to 0, making it closer to 2D
		position.z = 0
	
	if player == 0:
			$Armature/Skeleton3D/Cube.set_surface_override_material(0, null)
			$SpotLight3D.light_color = "ffffff"
			$SubViewport/Node2D/Player_Label.text = "CPU"
			$SubViewport/Node2D.modulate = "ffffff"
			
	else:
		if $Armature/Skeleton3D/Cube.get_surface_override_material(0) != player_mats[player_input]:
			$Armature/Skeleton3D/Cube.set_surface_override_material(0, player_mats[player_input])
			$SpotLight3D.light_color = player_hex[player_input]
			$SubViewport/Node2D/Player_Label.text = str("P", player)
			$SubViewport/Node2D.modulate = player_hex[player_input]
	#Character Appearence
	
		
	# INPUTS AS BOOLS
	
	
	var input_right = Input.is_action_pressed(str("Right", player))
	var input_left = Input.is_action_pressed(str("Left", player))
	var input_down = Input.is_action_pressed(str("Down", player))
	var input_up = Input.is_action_pressed(str("Up", player))
	
	# INPUTS AS BOOLS JUST PRESSED
	var input_right_just = Input.is_action_just_pressed(str("Right", player))
	var input_left_just = Input.is_action_just_pressed(str("Left", player))
	var input_down_just = Input.is_action_just_pressed(str("Down", player))
	var input_up_just = Input.is_action_just_pressed(str("Up", player))
	
	# INPUT ACTION STRENGTH AS FLOATS FOR CONTROLLERS AND INTS FOR KEYBOARD
	var input_right_str = Input.get_action_strength(str("Right", player))
	var input_left_str = Input.get_action_strength(str("Left", player))
	var input_down_str = Input.get_action_strength(str("Down", player))
	var input_up_str = Input.get_action_strength(str("Up", player))
	
	
	
	
	# FIGURE OUT MOVE AND SLIDE!!!!
	if input_right: # MOVING RIGHT
		velocity.x = 30
		
	if input_left: # Moving LEFT
		velocity.x = -30
		
	if input_down: # Moving DOWN
		gravity = 10
		
	else:
		gravity = 3
	velocity.x = velocity.x * 0.78
	
	
	if !is_on_floor():
		velocity.y -= gravity
		state = "on_air"
		
	else:
		state = "on_floor"
		_land()
		jumps = default_jumps
		jump_pow = default_jump_pow
		
		#$AnimationPlayer.play("Land")
		
	if input_up_just and is_on_floor():
		jump_request = true
		if state == "on_floor_jump":
			$AnimationPlayer.play()
	#elif jumps != 0 and input_up_just:
	#	jumps -= 1
	#	jump_pow = jump_pow / 1.1
#		velocity.y = jump_pow
	
	handle_anims()
		# Extra Jumps
	
	move_and_slide()
	
	if launch_force != 0:
		launched = true
	
	if launched == true:
		if launch_force != 0:
			var old_grav = gravity
			var y_decay = abs(launch_force)
			gravity = 8
			velocity.x += launch_force
			velocity.y += y_decay / 20
			y_decay = y_decay / 50
			launch_force = launch_force / 1.05
			if launch_force < 0.05:
				launched = false
				launch_force = 0
				gravity = old_grav
		
	#print(state)
	


func go_pos():
	if started == false:
		position = start_positions[player_input]
		started = true
			


func fix_player_number():
	if player != 0:
		player_input = player - 1
	elif player == 0:
		player_input = player


func visibility():
	if is_actually_visible == true:
		show()
	else:
		hide()

func handle_anims():
	print(state)
	
	if state == "on_floor":
		land = false
		land_count = 0
		$AnimationPlayer.play("Idle")
	if state == "on_air":
		$AnimationPlayer.play("Reset")
		

func _land():
	while land_count < 50:
		land_count += 1




func _on_animation_player_animation_changed(old_name, new_name):
	pass # Replace with function body.

func jump_1():
	
	velocity.y = jump_pow
	#$AnimationPlayer.play("Reset")
	jump_request = false

func _jump_process():
	if jump_request == true:
		state = "on_floor_jump"

func _process(delta):
	_jump_process()
