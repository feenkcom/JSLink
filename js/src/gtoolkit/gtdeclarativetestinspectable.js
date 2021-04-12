//
// This is a simple class that can be instantiated and demonstrates Gt views, 
// as exemplified in GtRemoteJavaScriptDeclarativeExamples in (the github repository)
//

var ViewBuilder = require('../gtoolkit/phlow/view_builder.js');

class GtDeclarativeTestInspectable {
    constructor () {
        this.string = 'hello world';
		this.collectionOfObjects = [ 42, 'Hello World', new Date("2021-04-06T14:43:49.623384+02:00") ];
    }

    gtViewList(builder) {
        return builder.list()
            .title('List')
            .priority(2)
            .items(() => this.collectionOfObjects)
            .itemFormat(item => {
                if (item.constructor.name == 'Date')
                    { return item.toISOString() }
                else
                    { return String(item) }})
    }

    gtViewColumnedList(builder) {
        return builder.columnedList()
            .title('Columned List')
            .priority(3)
            .items(() => this.collectionOfObjects)
            .column('Value', item => String(item), null)
            .column('Lowercase', item => String(item).toLowerCase(), 100)
    }

    gtViewString(builder) {
        return builder.textEditor()
            .title('String')
            .priority(1)
            .setString(this.string);
    }
}

module.exports = GtDeclarativeTestInspectable;

