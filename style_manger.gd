extends Node

var extra_bonus = {
	"explorer":{
		"score": 50,
		"name":"explorer"
	},
	"gamer":{
		"score": 30,
		"name":"gamer"
	},
	"speedrunner":{
		"score": 80,
		"name":"speedrunner"
	},
	"defeat":{
		"score": -100,
		"name":"defeat"
	},
	"no_hit":{
		"score": 300,
		"name":"no hit"
	}
}

@export var style_bonus = {
	"enemy_hit":{
		"score" : 0,
		"adrenaline": 5,
		"name" : "hit",
		"color":Color.GRAY
	},
	"enemy_killed":{
		"score" : 120,
		"adrenaline": 10,
		"name" : "kill",
		"color":Color.GRAY
	},
	"parried":{
		"score" : 40,
		"adrenaline": 20,
		"name" : "parry",
		"color":Color.GOLD
	},
	"one_shot":{
		"score" : 80,
		"adrenaline": 10,
		"name" : "overkill",
		"color":Color.RED
	},
	"multikill":{
		"score" : 200,
		"adrenaline": 10,
		"name" : "multi kill",
		"color":Color.RED
	},
	"double_kill":{
		"score" : 150,
		"adrenaline": 10,
		"name" : "double kill",
		"color":Color.GRAY
	},
	"triple_kill":{
		"score" : 170,
		"adrenaline": 10,
		"name" : "triple kill",
		"color":Color.INDIAN_RED
	},
	"ultrakill":{
		"score" : 30,
		"adrenaline": 10,
		"name" : "ultrakill",
		"color":Color.GOLDENROD
	},
	"shildbreak":{
		"score" : 100,
		"adrenaline": 50,
		"name" : "shild break",
		"color":Color.AQUA
	},
	"blocked":{
		"score" : 80,
		"adrenaline": 30,
		"name" : "blocked",
		"color":Color.RED
	},
	"test":{
		"score" : 50,
		"adrenaline": 50,
		"name" : "test",
		"color":Color.LIGHT_PINK
	},
	"crushed":{
		"score" : 20,
		"adrenaline": 5,
		"name" : "crushed",
		"color":Color.GRAY
	},
	"airkill":{
		"score" : 50,
		"adrenaline": 10,
		"name" : "airkill",
		"color":Color.GRAY
	},
	"absobed":{
		"score" : 50,
		"adrenaline": 10,
		"name" : "absobed",
		"color":Color.GRAY
	},
	"trick_shot":{
		"score" : 20,
		"adrenaline": 10,
		"name" : "trickshot",
		"color":Color.INDIAN_RED
	},
	"chared":{
		"score" : 10,
		"adrenaline": 10,
		"name" : "chared",
		"color":Color.CORAL
	},
	"grenadePunch":{
		"score" : 40,
		"adrenaline": 10,
		"name" : "quick gas",
		"color":Color.INDIAN_RED
	},
	"redirect":{
		"score" : 40,
		"adrenaline": 10,
		"name" : "redirect",
		"color":Color.GREEN
	}
} 
