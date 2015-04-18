package main

import (
	"config"
	"database/sql"
	"friend"

	"user"

	_ "github.com/go-sql-driver/mysql"
	"github.com/hoisie/web"
)

func main() {
	db, err := sql.Open(config.DbName, config.DbConnection)
	if err != nil {
		panic(err.Error())
	}
	err = db.Ping()
	if err != nil {
		panic(err.Error())
	}
	req := new(user.EventRequest)
	freq := new(friend.EventRequest)
	defer db.Close()
	req.DB = db
	freq.DB = db

	web.Get("/hello", hello)
	web.Get("/user/login", req.Login)
	web.Get("/user/regist", req.Regist)
	web.Get("/user/refresh", req.Refresh)

	web.Get("/friend/getlist", freq.GetFriendList)
	web.Get("/friend/addfriend", freq.AddFriend)
	web.Get("/friend/deletefriend", freq.DeleteFriend)

	web.Run("0.0.0.0:1234")
}

func hello() string {
	return "hello world"
}
