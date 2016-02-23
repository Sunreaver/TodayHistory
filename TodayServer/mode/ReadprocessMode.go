package mode

type Book struct {
	ID        string        `json:"bookID"`
	Name      string        `json:"bookName"`
	Author    string        `json:"bookAuthor,omitempty"`
	Page      int           `json:"bookPage"`
	StartDate int64         `json:"startTime"`
	Deadline  int           `json:"deadLine"`
	Process   []BookProcess `json:"process,omitempty"`
}

type BookProcess struct {
	Day  int `bson:"day,json:"day"`
	Page int `bson:"page,json:"page"`
}
