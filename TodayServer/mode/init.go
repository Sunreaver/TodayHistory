package mode

import "gopkg.in/mgo.v2"

var (
	mongo *mgo.Session

	dbName    = "ReadManager"
	dbProcess = "ReadProcess"
)

func init() {
	connectDb()
}

func connectDb() error {
	var err error
	mongo, err = mgo.Dial("127.0.0.1")
	if err != nil {
		panic(err)
		return err
	}

	mongo.SetMode(mgo.Monotonic, true)
	return nil
}
