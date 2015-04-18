package friend

import (
	"database/sql"
	"encoding/json"
	"fmt"

	"github.com/hoisie/web"
)

type EventRequest struct {
	DB *sql.DB
}

func ReturnMsg(c string, station interface{}) string {
	m := make(map[string]interface{})
	m["c"] = c
	m["d"] = station
	b, _ := json.Marshal(m)
	return string(b)
}

func (dealer *EventRequest) CheckoutSelf(uid, token string) bool {
	var sqltoken string
	sqline := fmt.Sprintf("SELECT `TOKEN` FROM `USER` WHERE UID = \"%s\"", uid)
	rows, err := dealer.DB.Query(sqline)
	if err != nil {
		return false
	}
	for rows.Next() {
		rows.Scan(&sqltoken)

		if sqltoken == token {
			return true
		}
	}
	return false
}

func (dealer *EventRequest) GetFriendList(ctx *web.Context) string {
	// 验证个人信息
	uid := ctx.Params["uid"]
	token := ctx.Params["token"]
	isSuc := dealer.CheckoutSelf(uid, token)
	if !isSuc {
		return ReturnMsg("1", nil)
	}

	// 获取好友状态的1的联系人的 uid,name , portrait
	sqline := fmt.Sprintf("SELECT uid,name,portrait FROM user WHERE uid in(SELECT fid FROM friend WHERE uid=\"%s\" AND status = 1)", uid)
	rows, err := dealer.DB.Query(sqline)
	if err != nil {
		return ReturnMsg("2", nil)
	}
	a := [](map[string]string){}
	for rows.Next() {
		var fid, name, portrait string
		m := make(map[string]string)
		rows.Scan(&fid, &name, &portrait)
		m["fid"] = fid
		m["name"] = name
		m["portrait"] = portrait
		a = append(a, m)
	}
	return ReturnMsg("0", a)
}
