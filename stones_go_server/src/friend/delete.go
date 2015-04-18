package friend

import (
	"fmt"

	"github.com/hoisie/web"
)

func (dealer *EventRequest) DeleteFriend(ctx *web.Context) string {
	uid := ctx.Params["uid"]
	token := ctx.Params["token"]
	fid := ctx.Params["fid"]
	isSuc := dealer.CheckoutSelf(uid, token)
	if !isSuc {
		return ReturnMsg("1", nil)
	}

	//查询是否存在
	sqline := fmt.Sprintf("SELECT `status` FROM `friend` WHERE `fid` = \"%s\" AND `uid` = \"%s\"", fid, uid)
	rows, err := dealer.DB.Query(sqline)
	if err != nil {
		return ReturnMsg("2", nil)
	}
	var status string
	for rows.Next() {
		rows.Scan(&status)
		if status != "" {
			// exist fid , and delete it
			sqline = fmt.Sprintf("DELETE FROM `friend` WHERE `uid` = \"%s\" AND `fid` = \"%s\"", uid, fid)
			_, err = dealer.DB.Query(sqline)
			if err == nil {
				return ReturnMsg("0", nil)
			}
			return ReturnMsg("3", nil)
		}
	}

	// friend is not existing
	return ReturnMsg("4", nil)
}
