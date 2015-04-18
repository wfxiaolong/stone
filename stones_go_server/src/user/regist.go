package user

import (
	"fmt"
	"tools"

	"github.com/hoisie/web"
)

func (dealer *EventRequest) Regist(ctx *web.Context) string {
	uid := ctx.Params["uid"]
	psw := ctx.Params["psw"]

	var sqlpsw string
	var token string
	var stoken string

	if uid == "" || psw == "" {
		return ReturnStaus("1", "", "", "", "", "")
	}
	sqline := fmt.Sprintf("SELECT PSW,TOKEN,STOKEN FROM USER WHERE UID = \"%s\"", uid)
	rows, err := dealer.DB.Query(sqline)
	if err != nil {
		return ReturnStaus("1", "", "", "", "", "")
	}
	for rows.Next() {
		err = rows.Scan(&sqlpsw, &token, &stoken)
		if sqlpsw != "" || token != "" || stoken != "" {
			// regist query error
			return ReturnStaus("2", "", "", "", "", "")
		}
	}

	sqltoken := tools.GetMd5String(uid + psw + "stone")
	name, portrait := RandUserMsg()
	code, stoken := SendRYGetToken(uid, name, portrait)
	if code != 200 {
		return ReturnStaus("4", "", "", "", "", "")
	}
	sqline = fmt.Sprintf("INSERT INTO `user`(`uid`, `psw`, `token`, `stoken`, `name`, `portrait`) VALUES (\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\")", uid, psw, sqltoken, stoken, name, portrait)
	_, err = dealer.DB.Query(sqline)
	if err != nil {
		// sql excus error
		return ReturnStaus("3", "", "", "", "", "")
	}
	return ReturnStaus("0", uid, sqltoken, stoken, name, portrait)
}
