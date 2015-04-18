package user

import (
	"fmt"
	"tools"

	"github.com/hoisie/web"
)

func (dealer *EventRequest) Login(ctx *web.Context) string {
	uid := ctx.Params["uid"]
	token := ctx.Params["token"]
	psw := ctx.Params["psw"]

	var sqltoken string
	var sqlpsw string
	var stoken string
	var name string
	var portrait string

	sqline := fmt.Sprintf("SELECT `TOKEN`,`PSW`,`STOKEN`,`NAME`,`PORTRAIT` FROM `USER` WHERE UID = \"%s\"", uid)
	rows, err := dealer.DB.Query(sqline)
	if err != nil {
		// sqline error
		return ReturnStaus("1", uid, "", "", "", "")
	}

	for rows.Next() {
		rows.Scan(&sqltoken, &sqlpsw, &stoken, &name, &portrait)
		if sqltoken == token {
			// login success by token
			return ReturnStaus("0", uid, sqltoken, stoken, name, portrait)
		} else if sqlpsw == psw {
			sqltoken = tools.GetMd5String(uid + sqlpsw + "stone")
			code, stoken := SendRYGetToken(uid, portrait, name)
			if code != 200 {
				// can't get server token
				return ReturnStaus("4", uid, "", "", name, portrait)
			}
			sqline = fmt.Sprintf("UPDATE `user` SET `token`=\"%s\",`stoken`=\"%s\" WHERE uid = \"%s\"", sqltoken, stoken, uid)
			dealer.DB.Query(sqline)
			// login success by password
			return ReturnStaus("0", uid, sqltoken, stoken, name, portrait)
		} else {
			// password error
			return ReturnStaus("2", uid, "", "", "", "")
		}
	}
	// can't find
	return ReturnStaus("3", uid, "", "", "", "")
}
