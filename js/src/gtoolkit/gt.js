var ViewBuilder = require('./phlow/view_builder');
var builder = new ViewBuilder();


class GtViewedObject {
    constructor(obj) {
        this.object = obj; }

    static attributesFor(anObject) {
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


	// Answer the set of methods that are Gt views
	getGtViewMethodNames() {
        let viewMethods = ['gtViewRaw', 'gtViewPrint'];
        Object.getOwnPropertyNames(Object.getPrototypeOf(this.object)).forEach(propertyName => {
            let property = this.object[propertyName];
            if(typeof property == "function" & propertyName.startsWith('gtView')) {
                viewMethods.push(propertyName);
            }
        });
        return viewMethods; }


	getViewDeclaration(viewName) {
		if (['gtViewRaw', 'gtViewPrint'].includes(viewName))
			return this[viewName](builder).asDictionaryForExport();
		else
			return this.object[viewName](builder).asDictionaryForExport(); }


    gtViewRaw(aBuilder) {
        return aBuilder.table()
            .title('Raw')
            .priority(9998)
            .items(() => GtViewedObject.attributesFor(this.object))
            .column('Item', item => item[0])
            .column('Value', item => item[1])
            .accessor('GtDeclarativeInstanceVarAccessor')
    }

    gtViewPrint(aBuilder) {
        return aBuilder.textEditor()
            .title('Print')
            .priority(9999)
            .setString('a(n) ' + this.object.constructor.name)
    }

}

module.exports = GtViewedObject;
