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
	DB_ERROR = map[string]interface{}{
		"status": 500,
		"msg":    "读取数据库失败",
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
		ctx.JSON(501, JSON_ERROR)
		return
	}

	var form []mode.Book
	e = json.Unmarshal([]byte(data.Read), &form)
	if e != nil {
		ctx.JSON(502, JSON_ERROR)
		return
	}

	saveData(ctx, form)
}

func UploadReadprocessGet(ctx *macaron.Context) {
	body := ctx.Query("readprocess")

	var form []mode.Book
	e := json.Unmarshal([]byte(body), &form)
	if e != nil {
		ctx.JSON(500, JSON_ERROR)
		return
	}

	saveData(ctx, form)
}

func ReadprocessGet(ctx *macaron.Context) {

	books, e := mode.GetReadprocess()
	if e != nil {
		ctx.JSON(200, DB_ERROR)
		return
	}

	ctx.JSON(200, map[string]interface{}{
		"status": 200,
		"msg":    "OK",
		"body":   books,
	})
}

func saveData(ctx *macaron.Context, form []mode.Book) {

	add := 0
	update := 0
	eNum := 0

	for _, v := range form {
		m, err := v.SaveDB()
		if err == nil {
			if m == mode.Add {
				add++
			} else if m == mode.Update {
				update++
			}
		} else {
			eNum++
		}
	}
	fmt.Printf("add=%d,update=%d,err=%d\r\n", add, update, eNum)

	ctx.JSON(200, map[string]interface{}{
		"status": 200,
		"msg":    "上传成功",
		"body": map[string]int{
			"add":    add,
			"update": update,
			"err":    eNum,
		},
	})
}
