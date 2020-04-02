var View = require('./view');

class SerialisableTreeMapView extends View {
    constructor() {
        super();
        this.itemsComputation = [];
        this.itemsGroupingComputatin = {};
        this.groupLabelComputation = [];
    }

    items(itemsComputation) {
        this.itemsComputation = itemsComputation;
        return this;
    }

    grouping(itemsGroupingComputatin) {
        this.itemsGroupingComputatin = itemsGroupingComputatin
        return this;
    }

    groupLabel(groupLabelComputation) {
        this.groupLabelComputation = groupLabelComputation;
        return this;
    }

    asDictionaryForExport() {
        let exportData = super.asDictionaryForExport();
        exportData['type'] = 'treemap';
       
        exportData['items'] = this.itemsComputation;
        exportData['grouping'] = this.itemsGroupingComputatin;
        exportData['groupLabel'] = this.groupLabelComputation;

        return exportData;
    }
}

module.exports = SerialisableTreeMapView;