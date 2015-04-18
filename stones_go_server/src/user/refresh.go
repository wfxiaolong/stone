package user

import (
	"fmt"

	"github.com/hoisie/web"
)

func (dealer *EventRequest) Refresh(ctx *web.Context) string {
	uid := ctx.Params["uid"]
	token := ctx.Params["token"]

	var sqltoken string
	var sqlname string
	var portrait string

	if uid == "" || token == "" {
		return ReturnStaus("1", "", "", "", "", "")
	}
	sqline := fmt.Sprintf("SELECT TOKEN, NAME, PORTRAIT FROM USER WHERE UID = \"%s\"", uid)
	rows, err := dealer.DB.Query(sqline)
	if err != nil {
		return ReturnStaus("1", "", "", "", "", "")
	}
	for rows.Next() {
		err = rows.Scan(&sqltoken, &sqlname, &portrait)
		if err != nil {
			// query error
			return ReturnStaus("2", "", "", "", "", "")
		}
	}
	if sqltoken != token {
		// token error
		return ReturnStaus("5", "", "", "", "", "")
	}

	code, stoken := SendRYGetToken(uid, sqlname, portrait)
	fmt.Println("get servertoken:" + stoken)
	if code != 200 {
		return ReturnStaus("4", "", "", "", "", "")
	}
	sqline = fmt.Sprintf("UPDATE `user` SET `stoken` = \"%s\" WHERE `uid` = \"%s\"", stoken, uid)
	_, err = dealer.DB.Query(sqline)
	if err != nil {
		// sql excus error
		return ReturnStaus("3", "", "", "", "", "")
	}
	return ReturnStaus("0", uid, sqltoken, stoken, sqlname, portrait)
}
