var nextId = 1;

class ViewedObject {
    constructor(obj, objName) {
        this.id = nextId++;
        this.object = obj;
        this.name = objName;
        this.isInspectorLiteral = typeof obj == 'string' 
				|| typeof obj == 'number';
    }

    static viewsFor(anObject) {
        var views = [];
        var keys = Object.keys(anObject);
        var key;
        var value;

        for (key of keys) {
            value = new this(anObject[key], key);
            views.push(value);
        }
        return views;
    }

    getId() {
        return this.id;
    }

    getName() {
        return this.name;
    }

    getObject() {
        return this.object;
    }

    gtViewRaw(builder) {
        return builder.table()
            .title('Raw')
            .priority(9998)
            .items(() => ViewedObject.viewsFor(this.object))
            .column('Item', item => item.name)
            .column('Value', item => item.object)
    }

    gtViewPrint(builder) {
        return builder.textEditor()
            .title('Print')
            .priority(9999)
            .setString('a(n) ' + this.object.constructor.name)
    }

}

module.exports = ViewedObject;

