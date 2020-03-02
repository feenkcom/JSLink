var View = require('./view');

class CircularPackView extends View {
    constructor() {
        super();
        this.itemsCallback = () => {[]};
        this.circleNameCallback = null;
        this.circleSizeCallback = null;
    }

    items(itemsCallback) {
        this.itemsCallback = itemsCallback;
        return this;
    }

    circleName(circleNameCallback) {
        this.circleNameCallback = circleNameCallback;
        return this;
    }

    circleSize(circleSizeCallback) {
        this.circleSizeCallback = circleSizeCallback;
        return this;
    }

    computeItems() {
        return this.itemsCallback();
    }

    asDictionaryForExport() {
        let exportData = super.asDictionaryForExport();
        exportData['viewName'] = 'GtDeclarativeCircularPackView';
        exportData['dataTransport'] = 1;
        exportData['circleData'] = this.computeItems().map( 
            item => {return {
                name: this.circleNameCallback(item),
                size: this.circleSizeCallback(item),
            }}
        );
        return exportData;
    }
}

module.exports = CircularPackView;
