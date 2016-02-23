package ctl

import (
	"encoding/json"
	"fmt"

	"../mode"
	"gopkg.in/macaron.v1"
)

var (
	FORM_ERROR = map[string]interface{}{
		"status": 500,
		"msg":    "推送的参数错误",
	}
	JSON_ERROR = map[string]interface{}{
		"status": 500,
		"msg":    "解析参数失败",
	}
)

type UploadForm struct {
	Read string `json:"readprocess"`
}

func UploadReadprocess(ctx *macaron.Context) {
	b, e := ctx.Req.Body().Bytes()
	if e != nil {
		ctx.JSON(500, FORM_ERROR)
		return
	}

	var data UploadForm
	e = json.Unmarshal(b, &data)
	if e != nil {
		fmt.Println(e.Error())
		ctx.JSON(500, JSON_ERROR)
		return
	}
	fmt.Println(data.Read)

	var form []mode.Book
	e = json.Unmarshal([]byte(data.Read), &form)
	if e != nil {
		ctx.JSON(500, JSON_ERROR)
		return
	}

	ctx.JSON(200, map[string]interface{}{
		"status": 200,
		"msg":    "上传成功",
	})
}

func UploadReadprocessGet(ctx *macaron.Context) {
	body := ctx.Query("readprocess")

	var form []mode.Book
	e := json.Unmarshal([]byte(body), &form)
	if e != nil {
		ctx.JSON(500, JSON_ERROR)
		return
	}

	for _, v := range form {
		fmt.Println(v.Name)
	}

	ctx.JSON(200, map[string]interface{}{
		"status": 200,
		"msg":    "上传成功",
		"body":   form,
	})
}
