package user

import (
	"config"
	"crypto/sha1"
	"database/sql"
	"encoding/json"
	"fmt"
	"io"
	"math/rand"
	"strconv"
	"time"

	"github.com/astaxie/beego/httplib"
)

type EventRequest struct {
	DB *sql.DB
}

func ReturnStaus(c, uid, token, stoken, name, portrait string) string {
	m := make(map[string]interface{})
	m["c"] = c
	m["uid"] = uid
	m["ts"] = time.Now().Unix()
	m["token"] = token
	m["stoken"] = stoken
	m["name"] = name
	m["portrait"] = portrait
	b, _ := json.Marshal(m)
	return string(b)
}

// rongyun token rep
type RongyunRep struct {
	Code  int    `json:"code"`
	Uid   string `json:"userId"`
	Token string `json:"token"`
}

type RCServer struct {
	apiUrl    string
	appKey    string
	appSecret string
}

func SendRYGetToken(uid string, name string, portrait string) (code int, token string) {
	req := httplib.Post(config.RC_USER_GET_TOKEN)
	req.Param("userId", uid)
	req.Param("name", name)
	req.Param("portrait", portrait)
	rcServer := &RCServer{
		apiUrl:    config.RC_SERVER_API_URL,
		appKey:    config.APP_KEY,
		appSecret: config.APP_SECRET,
	}
	fillHeader(req, rcServer)
	byteData, err := req.Bytes()
	var result RongyunRep
	fmt.Println(string(byteData))
	err = json.Unmarshal(byteData, &result)
	if err != nil {
		code = 800
		token = ""
	} else {
		code = result.Code
		token = result.Token
	}
	return code, token
}

// sdk sign
func fillHeader(req *httplib.BeegoHttpRequest, rcServer *RCServer) {
	nonce, timestamp, signature := getSignature(rcServer)
	req.Header("App-Key", rcServer.appKey)
	req.Header("Nonce", nonce)
	req.Header("Timestamp", timestamp)
	req.Header("Signature", signature)
}

//本地生成签名
func getSignature(rcServer *RCServer) (nonce, timestamp, signature string) {
	nonceInt := rand.Int()
	nonce = strconv.Itoa(nonceInt)
	timeInt64 := time.Now().Unix()
	timestamp = strconv.FormatInt(timeInt64, 10)
	h := sha1.New()
	io.WriteString(h, rcServer.appSecret+nonce+timestamp)
	signature = fmt.Sprintf("%x", h.Sum(nil))
	return
}
