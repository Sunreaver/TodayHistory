package mode

import "gopkg.in/mgo.v2/bson"

type Book struct {
	ID        string        `bson:"bookID" json:"bookID"`
	Name      string        `bson:"bookName" json:"bookName"`
	Author    string        `bson:"bookAuthor,omitempty" json:"bookAuthor,omitempty"`
	Page      int           `bson:"bookPage" json:"bookPage"`
	StartDate int64         `bson:"startTime" json:"startTime"`
	Deadline  int           `bson:"deadLine" json:"deadLine"`
	Process   []BookProcess `bson:"process,omitempty" json:"process,omitempty"`
}

type BookProcess struct {
	Day  int `bson:"day" json:"day"`
	Page int `bson:"page" json:"page"`
}

const (
	Add = iota
	Update
	Err
)

func (b *Book) SaveDB() (int, error) {
	m := mongo.Copy()
	defer m.Close()

	info, e := m.DB(dbName).C(dbProcess).Upsert(bson.M{"bookID": b.ID}, b)
	if e != nil {
		return Update, e
	} else if info.UpsertedId != nil {
		return Add, nil
	} else {
		return Update, nil
	}
}
