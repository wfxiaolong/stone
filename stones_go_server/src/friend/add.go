package friend

import (
	"fmt"

	"github.com/hoisie/web"
)

func (dealer *EventRequest) AddFriend(ctx *web.Context) string {
	uid := ctx.Params["uid"]
	token := ctx.Params["token"]
	fid := ctx.Params["fid"]
	isSuc := dealer.CheckoutSelf(uid, token)
	if fid == uid {
		isSuc = true
	}
	if !isSuc {
		return ReturnMsg("1", nil)
	}

	//checkout the friendList
	sqline := fmt.Sprintf("SELECT friend.status,user.token FROM `friend`,`user` WHERE friend.fid = \"%s\" AND friend.uid = \"%s\" AND user.uid = \"%s\"", fid, uid, fid)
	rows, err := dealer.DB.Query(sqline)
	if err != nil {
		return ReturnMsg("2", nil)
	}
	var status string
	fmt.Println("the sqline:" + sqline)
	for rows.Next() {
		rows.Scan(&status, &token)
		if status != "" {
			// exist fid friend
			return ReturnMsg("3", nil)
		}
	}

	//checkOut the fid
	var stoken string
	sqline = fmt.Sprintf("SELECT stoken FROM `user` WHERE user.uid = \"%s\"", fid)
	rows, err = dealer.DB.Query(sqline)
	if err != nil {
		return ReturnMsg("4", nil)
	}
	isResult := false
	for rows.Next() {
		isResult = true
		rows.Scan(&stoken)
		if stoken == "" {
			return ReturnMsg("5", nil)
		}
	}

	if isResult {
		// add friend
		sqline = fmt.Sprintf("INSERT INTO `friend` (`uid`,`fid`,`status`) VALUES (\"%s\", \"%s\", \"1\")", uid, fid)
		fmt.Println("sqline:" + sqline)
		_, err = dealer.DB.Query(sqline)
		if err == nil {
			return ReturnMsg("0", nil)
		}
	}

	// stoken can't find or sql error
	return ReturnMsg("6", nil)
}
