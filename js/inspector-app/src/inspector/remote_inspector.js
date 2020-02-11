var ViewBuilder = require('../phlow/view_builder');

class RemoteInspector {
    constructor() {
        this.objectIdsByName = {};
        this.objectViewsAccessors = {};
    }
    
    register(targetObject, id, name) {
        this.objectViewsAccessors[id] = new DeclarativeObjectViewsAccessor(targetObject);
    }

    registerNamedObject(object, id, name) {
        this.objectIdsByName[name] = id;
        this.register(object, id);
    }

    namedObjects() {
        return this.objectIdsByName;
    }

    computeViewsData(objectId) {
        let viewsAccessor = this.objectViewsAccessors[objectId];
        let viewsData = viewsAccessor.getViewAccessors().map(declarativeViewAccessor => { 
            return declarativeViewAccessor.viewSummaryForExport(objectId);
        });
        return {
            name: viewsAccessor.getTargetObject().getName(),
            accessors: viewsData,
        };
    }

    computeViewDefinition(objectId, viewId) {
        let viewsAccessor = this.objectViewsAccessors[objectId];
        let viewAccessor = viewsAccessor.findViewAccessorWithId(viewId);        
        return viewAccessor.viewDefinitionForExport();
    }

    computeSelectedObjectViewData(objectId, viewId, itemKey) {
        let viewsAccessor = this.objectViewsAccessors[objectId];
        let viewAccessor = viewsAccessor.findViewAccessorWithId(viewId);
        let nextObject = viewAccessor.getView().computeItems()[itemKey];
        if (nextObject.isInspectorLiteral)
            return nextObject.getObject();
        this.register(nextObject, nextObject.getId());
        return this.computeViewsData(nextObject.getId());
    }
}

class DeclarativeObjectViewsAccessor  {
    constructor(targetObject) {
        this.targetObject = targetObject;
        this.viewAccessors = null;
    }

    getTargetObject() {
        return this.targetObject;
    }

    getViewAccessors() {
        this._ensureViewAccessors();
        return this.viewAccessors;
    }

    _ensureViewAccessors() {
        if (this.viewAccessors !== null) {
            return ;
        }

        let viewMethods = this._getViewMethods();
        this.viewAccessors = viewMethods.map(viewMethod => {
            let view = this.targetObject[viewMethod.name](new ViewBuilder());
            return new DeclarativeViewAccessor(
                viewMethod.name,
                view,
                this.targetObject,
            );
        });
    }

    findViewAccessorWithId(viewId) {
        let viewAccessors = this.getViewAccessors();
        let viewAccessor = viewAccessors.find(each => each.getViewId() === viewId);
        return viewAccessor;
    }

    _getViewMethods() {
        let viewMethods = [];
        Object.getOwnPropertyNames(Object.getPrototypeOf(this.targetObject)).forEach(propertyName => {
            let property = this.targetObject[propertyName];
            if(typeof property == "function" & propertyName.startsWith('gtView')) {
                viewMethods.push(property);
            }
        });
        return viewMethods;
    }
}

class DeclarativeViewAccessor {
    constructor(viewId, view, targetObject) {
        this.viewId = viewId;
        this.view = view;
        this.targetObject = targetObject;
    }

    getView() {
        return this.view;
    }

    getViewId() {
        return this.viewId;
    }

    getTitle() {
        return this.view.getTitle();
    }

    getPriority() {
        return 1;
    }

    viewSummaryForExport(objectId) {
        return [
            this.getTitle(),
            this.getPriority(),
            `/object/${objectId}/${this.getViewId()}`,
        ];
    }

    viewDefinitionForExport() {
        return this.view.asDictionaryForExport();
    }
}

module.exports = RemoteInspector;
