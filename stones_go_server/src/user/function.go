package user

import (
	"config"
	"math/rand"
	"time"
)

func RandUserMsg() (name, portrait string) {
	r := rand.New(rand.NewSource(time.Now().UnixNano()))
	a := r.Intn(8) + 1
	switch a {
	case 1:
		name = config.USER_NAME_1
		portrait = config.USER_ICON_2
	case 2:
		name = config.USER_NAME_2
		portrait = config.USER_ICON_2
	case 3:
		name = config.USER_NAME_3
		portrait = config.USER_ICON_3
	case 4:
		name = config.USER_NAME_4
		portrait = config.USER_ICON_4
	case 5:
		name = config.USER_NAME_5
		portrait = config.USER_ICON_5
	case 6:
		name = config.USER_NAME_6
		portrait = config.USER_ICON_6
	case 7:
		name = config.USER_NAME_7
		portrait = config.USER_ICON_7
	case 8:
		name = config.USER_NAME_8
		portrait = config.USER_ICON_8
	default:
		name = config.USER_NAME_9
		portrait = config.USER_ICON_9
	}
	return name, portrait
}
