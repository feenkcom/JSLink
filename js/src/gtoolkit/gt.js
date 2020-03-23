var ViewBuilder = require('./phlow/view_builder');
var builder = new ViewBuilder();


class GtViewedObject {
    constructor(obj) {
        this.object = obj; }

    attributesFor(anObject) {
        var attributes = [];
        var keys = Object.keys(anObject);
        var key;

        for (key of keys) {
            attributes.push([ key, anObject[key] ]);
        }
        return attributes;
    }


    getObject() {
        return this.object;
    }


    // Answer the set of method names the receiver's object understands
    getMethodNames() {
        let methodNames = [];

        Object.getOwnPropertyNames(Object.getPrototypeOf(this.object)).forEach(propertyName => {
            // getter methods can throw exceptions.
            // We're not interested in getter methods, so ignore any exceptions
            try {
                let property = this.object[propertyName];
                if(typeof property == "function") {
                    methodNames.push(propertyName);
                }
            }
            catch (err) {}
        });
        return methodNames;
    }


	// Answer the set of methods that are Gt views
	getGtViewMethodNames() {
        return this.getMethodNames()
                    .filter((pN) => pN.startsWith('gtView'))
                    .concat(['gtViewRaw', 'gtViewPrint']);
    }


    // Answer the set of moethds that are Gt serialisable views
    getGtSerialisableViewMethodNames() {
        return this.getMethodNames()
                    .filter((pN) => pN.startsWith('gtSerialisable'));
    }


	getViewDeclaration(viewName) {
		if (['gtViewRaw', 'gtViewPrint'].includes(viewName))
			return this[viewName](builder).asDictionaryForExport();
		else
			return this.object[viewName](builder).asDictionaryForExport(); }


	sentItem(viewName, selection) {
		let view;
		if (['gtViewRaw', 'gtViewPrint'].includes(viewName))
			view = this[viewName](builder);
		else
			view = this.object[viewName](builder);
		return view.accessor(selection); }


    gtViewRaw(aBuilder) {
        return aBuilder.columnedList()
            .title('Raw')
            .priority(9998)
            .items(() => this.attributesFor(this.object))
            .column('Item', item => item[0])
            .column('Value', item => item[1])
            .set_accessor((selection) =>
				this.attributesFor(this.object)[selection-1][1])
    }

    gtViewPrint(aBuilder) {
        return aBuilder.textEditor()
            .title('Print')
            .priority(9999)
            .setString('a(n) ' + this.object.constructor.name)
    }

}

module.exports = GtViewedObject;
