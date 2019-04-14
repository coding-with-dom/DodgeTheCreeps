extends Node

export (PackedScene) var Mob
const LEVEL_SPEED_OFFSET = 50
const PITCH_SPEED_OFFSET = 0.05
var score
var level

func _ready():
    randomize()

func game_over():
    $ScoreTimer.stop()
    $MobTimer.stop()
    $LevelTimer.stop()
    $HUD.show_game_over()
    $Music.stop()
    $DeathSound.play()

func new_game():
    score = 0
    level = 1
    $Music.pitch_scale = 1
    $Player.start($StartPosition.position)
    $StartTimer.start()
    $HUD.update_score(score)
    $HUD.show_message("Get Ready")
    $Music.play()

func _on_StartTimer_timeout():
	$ScoreTimer.start()
	$MobTimer.start()
	$LevelTimer.start()

func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_MobTimer_timeout():
    # Choose a random location on Path2D.
    $MobPath/MobSpawnLocation.set_offset(randi())
    # Create a Mob instance and add it to the scene.
    var mob = Mob.instance()
    add_child(mob)
    # Set the mob's direction perpendicular to the path direction.
    var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
    # Set the mob's position to a random location.
    mob.position = $MobPath/MobSpawnLocation.position
    # Add some randomness to the direction.
    direction += rand_range(-PI / 4, PI / 4)
    mob.rotation = direction
    # Set the velocity (speed & direction).
    var mob_speed = rand_range(mob.min_speed, mob.max_speed)
    mob_speed += (level - 1) * LEVEL_SPEED_OFFSET
    mob.linear_velocity = Vector2(mob_speed, 0)
    mob.linear_velocity = mob.linear_velocity.rotated(direction)

func _on_LevelTimer_timeout():
    level += 1
    $Music.pitch_scale += PITCH_SPEED_OFFSET
